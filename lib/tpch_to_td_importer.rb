require "tpch_to_td_importer/version"

module TpchToTdImporter
  class Importer
    TABLES = [
      {:name => 'nation',
       :prefix => 'n',
       :col_names => %w|nationkey name   regionkey comment|,
       :col_types => %w|long      string long      string|,
       :pk => 'nationkey',
      },
      {:name => 'region',
       :prefix => 'r',
       :col_names => %w|regionkey name   comment|,
       :col_types => %w|long      string string|,
       :pk => 'regionkey',
      },
      {:name => 'customer',
       :prefix => 'c',
       :col_names => %w|custkey name   address nationkey phone  acctbal mktsegment comment|,
       :col_types => %w|long    string string  long      string double  string     string|,
       :pk => 'custkey',
      },
      {:name => 'part',
       :prefix => 'p',
       :col_names => %w|partkey name   mfgr   brand  type   size container retailprice comment|,
       :col_types => %w|long    string string string string int  string    double      string|,
       :pk => 'partkey',
      },
      {:name => 'partsupp',
       :prefix => 'ps',
       :col_names => %w|partkey suppkey availqty supplycost comment|,
       :col_types => %w|long    long    int      double     string|,
       :pk => 'partkey',
      },
      {:name => 'supplier',
       :prefix => 's',
       :col_names => %w|suppkey name   address nationkey phone  acctbal comment|,
       :col_types => %w|long    string string  long      string double  string|,
       :pk => 'suppkey',
      },
      {:name => 'orders',
       :prefix => 'o',
       :col_names => %w|orderkey custkey orderstatus totalprice orderdate orderpriority clerk  shippriority comment|,
       :col_types => %w|long     long    string      double     long      string        string int          string|,
       :pk => 'orderdate',
       :time_columns => %w|orderdate|
      },
      {:name => 'lineitem',
       :prefix => 'l',
       :col_names => %w|orderkey partkey suppkey linenumber quantity extendedprice discount tax returnflag linestatus shipdate commitdate receiptdate shipinstruct shipmode comment|,
       :col_types => %w|long     long    long    long       double   double        double   double string  string     long     long       long        string       string   string|,
       :pk => 'shipdate',
       :time_columns => %w|shipdate commitdate receiptdate|
      },
    ]

    def initialize(config)
      @config = config
    end

    def run(cmd)
      puts cmd.strip
      puts `#{cmd}` unless @config[:dryrun]
    end

    def import
      tdcmd = "td -k #{@config[:apikey]} -e #{@config[:endpoint]}"

      # Create a database
      db = @config[:db]
      cmd = <<-EOS
        #{tdcmd} db:create #{db}
      EOS
      run(cmd)

      # Create tables and run import command
      TABLES.each do |tbl|
        name = tbl[:name]
        next unless @config[:table_to_upload].nil? || @config[:table_to_upload] == name

        col_names = (tbl[:col_names] + ['dummy']).map{|col_name| "#{tbl[:prefix]}_#{col_name}"}.join(',')
        col_types = (tbl[:col_types] + ['string']).join(',')
        pk = "#{tbl[:prefix]}_#{tbl[:pk]}"
      
        cmd = <<-EOS
          #{tdcmd} table:create #{db} #{name}
        EOS
        run(cmd)
      
        cmd = <<-EOS
          #{tdcmd} schema:set #{db} #{name} #{col_names.split(',').zip(col_types.split(',')).map{|x| x[0] + ':' + x[1]}.join(' ')}
        EOS
        run(cmd)
      
        indir = @config[:indir]
        tblFile = tbl.has_key?(:time_columns) ? "#{indir}/#{name}.converted.tbl" : "#{indir}/#{name}.tbl"
        cmd = <<-EOS
          #{tdcmd} import:upload --auto-create #{db}.#{name} --auto-perform --auto-commit --auto-delete --parallel 8 --format csv --delimiter "|" --columns #{col_names} --column-types #{col_types} -t #{pk} -T '%Y-%m-%d' -error-records-handling abort #{tblFile}
        EOS
        run(cmd)
      end
    end
  end
end

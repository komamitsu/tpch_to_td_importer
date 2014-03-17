# TpchToTdImporter

This Importer imports TPC-H data into TreasureData storage.

## Installation

Add this line to your application's Gemfile:

    gem 'tpch_to_td_importer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tpch_to_td_importer

## Usage

First, generate 100GB of TPC-H data in target/dataset/100 folder:
    $ make SCALING_FACTORS="100"

Next, run tpch_to_td_importer:
    # Upload the generated dataset in `target/dataset/100` (-i option) to the Treasure Data service.
    # The uploaded data is stored in `tpch` database. (-d option)
    $ bundle exec bin/tpch_to_td_importer -k myapykey12345678 -d tpch -i target/dataset/100

    $ cd foo/tpch_to_td_importer
    $ bundle exec bin/tpch_to_td_importer myapikey12345678 mydatabase


### Building dbgen manually
First, you need to get "dbgen" from http://www.tpc.org/tpch/ and generate TPC-H tbl files like in this way:
    $ cd tpch_2_15_0/dbgen
    $ cp -p makefile.suite Makefile
    $ vi Makefile
        :
      CC = gcc
      MACHINE =LINUX
      DATABASE =ORACLE
      WORKLOAD =TPCH
        :
    $ make
    $ dbgen -sf 100 # generates 100GB data
    $ cp -p *.tbl foo/tpch_to_td_importer


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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

First, you need to get "dbgen" from http://www.tpc.org/tpch/ and generate TPC-H tbl files like in this way:

    $ cd tpch_2_15_0/dbgen
    $ cp -p makefile.suite Makefile
    $ vi Makefile
        :
      MACHINE =LINUX
      WORKLOAD =TPCH
        :
    $ make
    $ dbgen -sf 100 # generates 100GB data
    $ cp -p *.tbl foo/tpch_to_td_importer

Next, run bin/tpch_to_td_importer

    $ cd foo/tpch_to_td_importer
    $ bundle exec bin/tpch_to_td_importer myapikey12345678 mydatabase


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

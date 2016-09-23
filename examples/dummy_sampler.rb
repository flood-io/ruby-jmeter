$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    dummy_sampler name: '__grid_data_api',
      response_data: 'ACIR0001, ACIR0002, ACIR0003, ACIR0004, ACIR0005, ACIR0006, ABS0003, MBS0001, MBS0004, MBS0005, ABS0004, ABS0005, ABS0010, ABS0011, ABS0012, ABS0013, ABS0014, ABS0016, ABS0017, ABS0018, ABS0021, ABS0022, MBS0006, MBS0009, MBS0010'
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)

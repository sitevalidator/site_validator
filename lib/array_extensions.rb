##
# Taken from https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/array/uniq_by.rb
class Array
  def uniq_by
    hash, array = {}, []
    each { |i| hash[yield(i)] ||= (array << i) }
    array
  end
end
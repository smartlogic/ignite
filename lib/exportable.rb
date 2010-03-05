require "fastercsv"

class ActiveRecord::Base
  def self.to_csv(*args)
    if args.size > 0
      find(*args).to_csv
    else
      find(:all).to_csv
    end
  end
  
  # Default is to export name -- Should be overridden in each model
  def export_columns
    self.class.content_columns.map(&:name) - ['created_at', 'updated_at']
  end
  
  def to_row(format = nil)
    export_columns(format).map { |c| self.send(c) }
  end
end

# Define to_csv on collections
class Array
  def to_csv
    if all? { |e| e.respond_to?(:to_row) }
      header_row = first.export_columns.to_csv
      content_rows = map { |e| e.to_row }.map(&:to_csv)
      ([header_row] + content_rows).join
    else
      FasterCSV.generate_line(self)
    end
  end
end
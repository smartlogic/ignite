class Comment < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true
  
  validates_presence_of :author, :content
  
  before_save :clean_attrs
  
  private
  
  def clean_attrs
    %w(content author email).each do |attr|
      self.send("#{attr}=", ContentCleaner.clean(self.send(attr))) unless self.send(attr).nil?
    end
    %w(url).each do |attr|
      self.send("#{attr}=", ContentCleaner.fix_link(self.send(attr))) unless self.send(attr).nil?
    end
  end
  
end

class Product < ActiveRecord::Base
  attr_accessible :title, :description, :image_url, :price, :weighting, :stock, :dimensions_attributes, :category_ids, :additional_option_ids, :dimension_ids
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true, :length => {:minimum => 10, :message => :too_short}
  validates :image_url, :format => {
  	:with => %r{\.(gif|png|jpg)$}i,
  	:message => "must be a URL for GIF, JPG or PNG image."
  } # all of the above validates the attributes of products
  default_scope :order => 'weighting' #orders the products by weighting
  has_many :line_items, :dependent => :destroy #each product has many line items in the various carts
  has_many :orders, :through => :line_items
  has_many :categorisations
  has_many :categories, :through => :categorisations
  has_many :accessorisations
  has_many :additional_options, :through => :accessorisations, :source => :product_option
  has_many :dimensionals
  has_many :dimensions, :through => :dimensionals
  accepts_nested_attributes_for :dimensions, :reject_if => lambda { |a| a[:size].blank? }
  before_destroy :reference_no_line_item #before destroy the product object, execute the following method shown below
  mount_uploader :image_url, ProductUploader

  private
  	def reference_no_line_item
  		if line_items.empty?
  		else
  			errors.add(:base, 'Line items present')
  		end # if line_items are present, it throws an error when attempting to delete the product
  	end
end
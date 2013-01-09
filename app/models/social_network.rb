class SocialNetwork < ActiveRecord::Base
  belongs_to :client
  has_attached_file :image, :default_url => "/assets/images/missing.png"
  validate :image, :attachment_presence => true
  attr_accessible :name, :client_id, :info_social_network_id, :id_object, :image

  has_many :history_comment, :dependent => :destroy

  has_many :blog_data, :dependent => :destroy
  has_many :facebook_data, :dependent => :destroy
  has_many :flickr_data, :dependent => :destroy
  has_many :google_plus_data, :dependent => :destroy
  has_many :linkedin_data, :dependent => :destroy
  has_many :pinterest_data, :dependent => :destroy
  has_many :tuenti_data, :dependent => :destroy
  has_many :tumblr_data, :dependent => :destroy
  has_many :twitter_data, :dependent => :destroy
  has_many :youtube_data, :dependent => :destroy
  has_many :foursquare_data, :dependent => :destroy
  has_many :benchmark_competitor, :dependent => :destroy
  has_many :rows_campaign, :dependent => :destroy
  has_many :monitoring, :dependent => :destroy
  has_many :summaries, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  def data_types
    [FacebookDatum, TwitterDatum, LinkedinDatum, BlogDatum, TuentiDatum, YoutubeDatum, 
      FoursquareDatum, PinterestDatum, GooglePlusDatum, FlickrDatum, TumblrDatum, Monitoring,
      BenchmarkDatum, RowsCampaign, Comment, Summary
    ]
  end
end

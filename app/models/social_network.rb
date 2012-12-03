class SocialNetwork < ActiveRecord::Base
  belongs_to :client
  has_attached_file :image, :default_url => "/assets/images/missing.png"
  validate :image, :attachment_presence => true

  has_many :blog_comment
  has_many :benchmark_comment
  has_many :facebook_comment
  has_many :flickr_comment
  has_many :google_plus_comment
  has_many :linkedin_comment
  has_many :pinterest_comment
  has_many :tuenti_comment
  has_many :tumblr_comment
  has_many :twitter_comment
  has_many :youtube_comment
  has_many :campaign_comment
  has_many :foursquare_comment
  has_many :monitoring_comment
  has_many :benchmark_comment
  has_many :images_social_network

  has_many :benchmark_data
  has_many :blog_data
  has_many :facebook_data
  has_many :flickr_data
  has_many :google_plus_data
  has_many :linkedin_data
  has_many :pinterest_data
  has_many :tuenti_data
  has_many :tumblr_data
  has_many :twitter_data
  has_many :youtube_data
  has_many :foursquare_data
  has_many :benchmark_competitor
  has_many :rows_campaign
  has_many :monitoring

  attr_accessible :name, :client_id, :info_social_network_id, :id_object, :image

  def data_types
    [FacebookDatum, Monitoring, BlogDatum, FlickrDatum, FoursquareDatum, GooglePlusDatum,
      LinkedinDatum, PinterestDatum, TuentiDatum, TumblrDatum, TwitterDatum, YoutubeDatum,
      BenchmarkDatum
    ]
  end
end

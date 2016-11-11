class Attachment < ActiveRecord::Base

  belongs_to :imageable, polymorphic: true

  has_attached_file :image,
                    styles: {
                              index: "318x250#",
                              show: "865x400!#",
                              featured: "248x130!",
                              related: "268x180!",
                              thumb: "100x80#",
                            },

                     default_url: "/images/:style/missing.png"

  validates_attachment :image, presence: true,
                        content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] },
                        size: { less_than: 10.megabytes }

end

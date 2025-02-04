class Board < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :camera_make, :camera_model, presence: true
  validates :custom_camera_make, presence: true, if: :other_camera_make?
  validates :board_image_url, presence: true
  
  belongs_to :camera
  belongs_to :user

  has_many :bookmarks, dependent: :destroy

  paginates_per 30


  has_one_attached :image
  has_one_attached :video
  has_one_attached :board_image

  def self.ransackable_attributes(auth_object = nil)
    [
      "board_image", "body", "camera_id", "camera_make", "camera_model", 
      "created_at", "id", "image_url", "title", "updated_at", "user_id"
    ]
  end
    
  def self.ransackable_associations(auth_object = nil)
    ["camera", "user"]  
  end

  before_validation :set_camera_id, on: [:create, :update]

  private

  def set_camera_id
    return if camera_make.blank? || camera_model.blank?
  
    camera = Camera.find_or_create_by(make: camera_make, model: camera_model)
    self.camera_id = camera.id
  end

  def other_camera_make?
    camera_make == "その他"
  end

    def custom_camera_make_if_other
    if camera_make == 'その他' && custom_camera_make.blank?
      errors.add(:custom_camera_make, 'カメラのメーカー名を入力してください')
    end
  end
end
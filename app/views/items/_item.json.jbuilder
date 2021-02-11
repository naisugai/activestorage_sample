json.extract! item, :id, :name, :description, :created_at, :updated_at
json.url item_url(item, format: :json)
json.image_id @image_blob.id if @image_blob

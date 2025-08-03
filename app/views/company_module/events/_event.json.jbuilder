json.extract! event, :id, :company_id, :name, :date_start, :date_end, :status, :created_at, :updated_at
json.url event_url(event, format: :json)

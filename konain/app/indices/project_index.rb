ThinkingSphinx::Index.define :project, with: :active_record, delta: true do

  indexes title
  has 'CRC32(city)', as: :city, type: :integer
  has 'CRC32(title)', as: :title_filter, type: :integer
  has id
  has project_id

  set_property min_infix_len: 3
end

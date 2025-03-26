# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'csv'
require 'open-uri'

puts 'Seeding categories and products from CSV...'

csv_text = File.read(Rails.root.join('db', 'piano_products_dataset.csv'))
csv = CSV.parse(csv_text, headers: true)

csv.each do |row|
  category = Category.find_or_create_by!(name: row['Category'])

  product = Product.create!(
    name: row['Name'],
    price: row['Price'].to_f,
    description: row['Description'],
    category: category,
    inventory_quantity: rand(10..50)
  )

  image_url = row['ImageURL']
  if image_url.present?
    downloaded_image = URI.open(image_url)
    product.image.attach(io: downloaded_image, filename: "#{product.name.parameterize}.jpg")
  end

  puts "Created product: #{product.name}"
end

puts "Successfully seeded #{Product.count} piano products!"


# i ran this later in my implemntation 
Page.find_or_create_by(slug: "about") do |page|
    page.title = "About Us"
    page.content = "This is the About Us page."
  end
  
  Page.find_or_create_by(slug: "contact") do |page|
    page.title = "Contact"
    page.content = "This is the Contact page."
  end
  
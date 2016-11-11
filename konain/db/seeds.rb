# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user =  User.where(email: 'admin@konain.com', name: 'Admin').first_or_initialize
user.password = 'password'
user.password_confirmation = 'password'
user.home_phone_code = '042'
user.home_phone_number = '11111111'
user.mobile_phone_code = '0300'
user.mobile_phone_number = '1111111'
user.role = 'admin'
user.save

puts 'New user created: ' << user.name
puts 'Email: ' << user.email

project = Project.where(title: 'Other - Lahore').first_or_initialize
project.city = 'Lahore'
project.country = 'Pakistan'
project.location = 'Lahore'
project.latitude = 31.55460609999999
project.longitude = 74.3571581000000
project.save

puts 'New project created: ' << project.title

sub_project = project.sub_projects.where(title: 'Other - Lahore Phase').first_or_initialize
sub_project.city = 'Lahore'
sub_project.country = 'Pakistan'
sub_project.location = 'Lahore'
sub_project.latitude = 31.55460609999999
sub_project.longitude = 74.3571581000000
sub_project.save

puts 'New sub_project created: ' << sub_project.title

project = Project.where(title: 'Other - Islamabad').first_or_initialize
project.city = 'Islamabad'
project.country = 'Pakistan'
project.location = 'Islamabad'
project.latitude = 33.7293882
project.longitude = 73.0931461
project.save

puts 'New project created: ' << project.title

sub_project = project.sub_projects.where(title: 'Other - Islamabad Phase').first_or_initialize
sub_project.city = 'Islamabad'
sub_project.country = 'Pakistan'
sub_project.location = 'Islamabad'
sub_project.latitude = 33.7293882
sub_project.longitude = 73.0931461
sub_project.save

puts 'New sub_project created: ' << sub_project.title

project = Project.where(title: 'Other - Karachi').first_or_initialize
project.city = 'Karachi'
project.country = 'Pakistan'
project.location = 'Karachi'
project.latitude = 24.8614622
project.longitude = 67.0099388
project.save

puts 'New project created: ' << project.title

sub_project = project.sub_projects.where(title: 'Other - Karachi Phase').first_or_initialize
sub_project.city = 'Karachi'
sub_project.country = 'Pakistan'
sub_project.location = 'Karachi'
sub_project.latitude = 24.8614622
sub_project.longitude = 67.0099388
sub_project.save

puts 'New sub_project created: ' << sub_project.title

page = Page.where(permalink: 'terms_and_conditions').first_or_initialize
page.name = 'Terms and Conditions'
page.permalink = 'terms_and_conditions'
page.content = 'Add some content for this page.'
page.save

puts 'New page created: ' << page.name

setting = Setting.where(title: 'News Ticker').first_or_initialize
setting.title = 'News Ticker'
setting.save

puts 'New setting created: ' << setting.title

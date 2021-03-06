require 'csv'

# [ VehicleMake, VehicleModel, Dealership, User, Vehicle, Photo, ListingScore, Discussion, DiscussionComment, Club, BusinessHour ].each do |model|
#   model.all.each(&:destroy)
# end

# Makes
CSV.foreach(Rails.root.join("vehicle_makes.csv"), headers: true) do |row|
  VehicleMake.create! do |vehicle_make|
    vehicle_make.id              = row[0]
    vehicle_make.name            = row[1]
    vehicle_make.cover_photo_url = row[2]
  end
end

# Models
CSV.foreach(Rails.root.join("vehicle_models.csv"), headers: true) do |row|
  VehicleModel.create! do |vehicle_model|
    vehicle_model.id              = row[0]
    vehicle_model.name            = row[1]
    vehicle_model.vehicle_make_id = row[2]
  end
end

# Dealerships
CSV.foreach(Rails.root.join("dealerships.csv"), headers: true) do |row|
  Dealership.create! do |dealership|
    dealership.id                         = row[0]
    dealership.dealership_name            = row[1]
    dealership.scrape_name                = row[2]
    dealership.email                      = row[3]
    dealership.activated                  = row[4]
    dealership.activated_at               = row[5]
    dealership.description                = row[6]
    dealership.website                    = row[7]
    dealership.sales_phone                = row[8]
    dealership.service_phone              = row[9]
    dealership.street_address             = row[10]
    dealership.building                   = row[11]
    dealership.city                       = row[12]
    dealership.state                      = row[13]
    dealership.latitude                   = row[14]
    dealership.longitude                  = row[15]
    dealership.logo                       = open(row[16]) unless row[16].nil?
    dealership.photo                      = open(row[17]) unless row[17].nil?
    dealership.last_run_start_at          = row[18]
    dealership.last_run_end_at            = row[19]
    dealership.last_run_total_records     = row[20]
    dealership.last_run_new_records       = row[21]
    dealership.last_run_duplicate_records = row[22]
    dealership.last_run_error_records     = row[23]
  end
end

# Users
CSV.foreach(Rails.root.join("users.csv"), headers: true) do |row|
  User.create! do |user|
    user.id                    = row[0]
    user.first_name            = row[1]
    user.last_name             = row[2]
    user.email                 = row[3]
    user.password              = row[4]
    user.password_confirmation = row[5]
    user.is_subscribed         = row[6]
    user.admin                 = row[7]
    user.activated             = row[8]
    user.activated_at          = row[9]
    user.avatar                = open(row[10]) unless row[10].nil?
    user.dealership_id         = row[11]
    user.dealership_admin      = row[12]
  end
end

# Vehicles
CSV.foreach(Rails.root.join("vehicles.csv"), headers: true) do |row|
  Vehicle.create! do |vehicle|
    vehicle.id                           = row[0]
    vehicle.dealership_id                = row[1]
    vehicle.user_id                      = row[2]
    vehicle.listing_name                 = row[3]
    vehicle.vehicle_make_name            = row[4]
    vehicle.vehicle_make_id              = row[5]
    vehicle.vehicle_model_name           = row[6]
    vehicle.vehicle_model_id             = row[7]
    vehicle.msrp                         = row[8]
    vehicle.actual_price                 = row[9]
    vehicle.year                         = row[10]
    vehicle.mileage                      = row[11]
    vehicle.mileage_numeric              = row[12]
    vehicle.body_style                   = row[13]
    vehicle.engine                       = row[14]
    vehicle.exterior                     = row[15]
    vehicle.interior                     = row[16]
    vehicle.fuel_type                    = row[17]
    vehicle.transmission                 = row[18]
    vehicle.drivetrain                   = row[19]
    vehicle.stock_number                 = row[20]
    vehicle.vin                          = row[21]
    vehicle.trim_details                 = row[22]
    vehicle.description                  = row[23]
    vehicle.description_clean            = row[24]
    vehicle.air_conditioning             = row[25]
    vehicle.power_windows                = row[26]
    vehicle.remote_keyless_entry         = row[27]
    vehicle.speed_control                = row[28]
    vehicle.am_fm_radio                  = row[29]
    vehicle.wireless_phone_connectivity  = row[30]
    vehicle.fully_automatic_headlights   = row[31]
    vehicle.variably_intermittent_wipers = row[32]
    vehicle.abs_brakes                   = row[33]
    vehicle.brake_assist                 = row[34]
    vehicle.dual_front_impact_airbags    = row[35]
    vehicle.electronic_stability         = row[36]
    vehicle.security_system              = row[37]
    vehicle.traction_control             = row[38]
    vehicle.power_steering               = row[39]
    
    # if vehicle.dealership_id.nil?
      vehicle.street_address             = row[40]
      vehicle.apartment                  = row[41]
      vehicle.city                       = row[42]
      vehicle.state                      = row[43]
      vehicle.latitude                   = row[44]
      vehicle.longitude                  = row[45]
    
    # else
    #   vehicle.street_address             = vehicle.dealership.street_address
    #   vehicle.apartment                  = vehicle.dealership.building
    #   vehicle.city                       = vehicle.dealership.city
    #   vehicle.state                      = vehicle.dealership.state
    #   vehicle.latitude                   = vehicle.dealership.latitude
    #   vehicle.longitude                  = vehicle.dealership.longitude
    # end
    
    vehicle.ad_url                       = row[46]
    vehicle.created_at                   = row[47]
    vehicle.posted_at                    = row[48]
    vehicle.bumped_at                    = row[49]
    vehicle.last_found_at                = row[50]
  end
end

# Listing Scores
CSV.foreach(Rails.root.join("listing_scores.csv"), headers: true) do |row|
  ListingScore.create! do |listing_score|
    listing_score.id                     = row[0]
    listing_score.vehicle_id             = row[1]
    listing_score.location_score         = row[2]
    listing_score.features_score         = row[3]
    listing_score.spec_score             = row[4]
    listing_score.vin_score              = row[5]
    listing_score.certified_dealer_score = row[6]
    listing_score.direct_listing_score   = row[7]
    listing_score.test_drive_score       = row[8]
    listing_score.photos_score           = row[9]
    listing_score.reviews_score          = row[10]
    listing_score.recently_posted_score  = row[11]
    listing_score.many_listings_score    = row[12]
    listing_score.overall_score          = row[13]
  end
end

# Photos
CSV.foreach(Rails.root.join("photos.csv"), headers: true) do |row|
  Photo.create! do |photo|
    photo.id            = row[0]
    photo.vehicle_id    = row[1]
    photo.image         = open(row[2]) unless row[2].nil?
    photo.last_found_at = row[3]
  end
end

# Discussions
CSV.foreach(Rails.root.join("discussions.csv"), headers: true) do |row|
  Discussion.create! do |discussion|
    discussion.id              = row[0]
    discussion.title           = row[1]
    discussion.content         = row[2]
    discussion.user_id         = row[3]
    discussion.cached_votes_up = row[4]
  end
end

# Discussion Comments
CSV.foreach(Rails.root.join("discussion_comments.csv"), headers: true) do |row|
  DiscussionComment.create! do |discussion_comment|
    discussion_comment.comment       = row[0]
    discussion_comment.discussion_id = row[1]
    discussion_comment.user_id       = row[2]
  end
end

# Clubs
CSV.foreach(Rails.root.join("clubs.csv"), headers: true) do |row|
  Club.create! do |club|
    club.id          = row[0]
    club.name        = row[1]
    club.description = row[2]
    club.cover_photo = open(row[3])
    club.city        = row[4]
    club.state       = row[5]
    club.latitude    = row[6]
    club.longitude   = row[7]
  end
end

# Business Hours
CSV.foreach(Rails.root.join("business_hours.csv"), headers: true) do |row|
  BusinessHour.create! do |business_hour|
    business_hour.id            = row[0]
    business_hour.day           = row[1]
    business_hour.open_time     = row[2]
    business_hour.close_time    = row[3]
    business_hour.is_closed     = row[4]
    business_hour.dealership_id = row[5]
  end
end
  
# User.create!(name:   "Example User",
#             email:  "example@railstutorial.org",
#             password:               "foobar",
#             password_confirmation:  "foobar",
#             is_subscribed: true,
#             admin:         true,
#             activated:     true,
#             activated_at: Time.zone.now)

# # seed data for comments (Listing 13.25)

# # Users
# User.create!(name:   "Example User",
#             email:  "example@railstutorial.org",
#             password:               "foobar",
#             password_confirmation:  "foobar",
#             is_subscribed: true,
#             admin:         true,
#             activated:     true,
#             activated_at: Time.zone.now)
             
# 99.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name:  name,
#               email: email,
#               password:              password,
#               password_confirmation: password,
#               is_subscribed: false,
#               activated:     true,
#               activated_at: Time.zone.now)
# end

# # Vehicles
# users = User.order(:created_at).take(6)
# 50.times do
#   users.each { |user| user.vehicles.create!(vehicle_condition:           "New",
#                                             body_style:                  "Pickup",
#                                             color:                       "Gray",
#                                             transmission:                "Automatic",
#                                             fuel_type:                   "Flex Fuel",
#                                             drivetrain:                  "All-Wheel Drive",
#                                             vin:                         "2G1FK3DJ0F9298212",
#                                             listing_name:                Faker::Lorem.word,
#                                             address:                     "262 Hudson Crescent, Wallaceburg ON",
#                                             year:                        2014,
#                                             price:                       Faker::Number.number(5),
#                                             mileage:                     Faker::Number.number(5),
#                                             seating_capacity:            5,
#                                             summary:                     Faker::Lorem.sentence, 
#                                             sellers_notes:               Faker::Lorem.sentence, 
#                                             is_leather_seats:            true,
#                                             is_sunroof:                  true,
#                                             is_navigation_system:        true,
#                                             is_dvd_entertainment_system: false,
#                                             is_bluetooth:                true,
#                                             is_backup_camera:            true,
#                                             is_remote_start:             true,
#                                             is_tow_package:              true,
#                                             is_autonomy:                 false) }
# end

# # Photos
# vehicle = Vehicle.all.last
# 8.times do 
#     vehicle.photos.create!(image: File.new("app/assets/images/gallery1.jpg"))
# end

# # Comments
# user    = User.all.last
# vehicle = Vehicle.all.last
# 3.times do
#   vehicle.comments.create!(title:   Faker::Lorem.word,
#                           content: Faker::Lorem.sentence,
#                           likes:   5,
#                           user:    user)
# end

# # Replies
# user    = User.all.last
# comment = Comment.all.last
# 3.times do
#   comment.replies.create!(content: Faker::Lorem.sentence,
#                           likes:   5,
#                           user:    user)
# end
  

# # Appointments
# # users.each { 
# #     users.each { |user| user.vehicles.order(:created_at).take(1) }
# #              user.vehicles.each { |vehicle| user.appointments.create!(vehicle_id: vehicle.id,
# #                                                     date:       Faker::Date.forward(10)) }
# # }

# # vehicles = users.each { |user| user.vehicles.order(:created_at).take(1) }
# # vehicle.id = vehicles.each { |vehicle| vehicle.id }
# # users.each { |user| user.appointments.create!(vehicle_id: vehicle.id,
# #                                                     date:       Faker::Date.forward(10)) }


# # vehicles = users.each { |user| user.vehicles.order(:created_at).take(1) }
# # users.each {
# #     vehicles.each { |vehicle| users.appointments.create!(vehicle_id: vehicle.id,
# #                                                     date:       Faker::Date.forward(10)) }
# # }


# # users.each { |user| vehicles  = user.vehicles.order(:created_at).take(1) 
# #              vehicles.each { |vehicle| user.appointments.create!(vehicle_id: vehicle.id,
# #                                                     date:       Faker::Date.forward(10)) }
# # }

# # users     = User.all
# # user      = users.first
# # vehicles  = Vehicle.take(6)
# # vehicles.each { |vehicle| user.appointments.create!(vehicle_id: vehicle.id,
# #                                                     date:       Faker::Date.forward(10)) }

# users     = User.all
# user1      = users.first
# user2      = users.second
# vehicle1s    = user1.vehicles.order(:created_at).take(1)
# vehicle2s    = user2.vehicles.order(:created_at).take(1)
# vehicle2s.each { |vehicle2| user1.appointments.create!(vehicle_id: vehicle2.id,
#                                                     date:       Faker::Date.forward(10)) }
# vehicle1s.each { |vehicle1| user2.appointments.create!(vehicle_id: vehicle1.id,
#                                                     date:       Faker::Date.forward(10)) }

# User.create(first_name: "Leslie", last_name: "Young", email: "leslie@davisgmc.com", password: "98391003", password_confirmation: "98391003", avatar: open("https://randomuser.me/api/portraits/women/23.jpg"), dealership_id: 3)
# User.create(first_name: "Matt", last_name: "Graves", email: "matt@royalauto.com", password: "98391004", password_confirmation: "98391004", avatar: open("https://randomuser.me/api/portraits/men/31.jpg"), dealership_id: 4)
# User.create(first_name: "Nicole", last_name: "Pratt", email: "nicole@sfhonda.com", password: "98391005", password_confirmation: "98391005", avatar: open("https://randomuser.me/api/portraits/women/49.jpg"), dealership_id: 5)
# User.create(first_name: "Neal", last_name: "Reyes", email: "neal@sftoyota.com", password: "98391006", password_confirmation: "98391006", avatar: open("https://randomuser.me/api/portraits/men/94.jpg"), dealership_id: 6)
# User.create(first_name: "Deanna", last_name: "Pearson", email: "deanna@sfbenz.com", password: "98391007", password_confirmation: "98391007", avatar: open("https://randomuser.me/api/portraits/women/23.jpg"), dealership_id: 7)
# User.create(first_name: "Noah", last_name: "Gray", email: "noah@bmwsf.com", password: "98391008", password_confirmation: "98391008", avatar: open("https://randomuser.me/api/portraits/men/85.jpg"), dealership_id: 8)
# User.create(first_name: "Lindsay", last_name: "Trieu", email: "lindsay@sfnissan.com", password: "98391009", password_confirmation: "98391009", avatar: open("https://randomuser.me/api/portraits/women/2.jpg"), dealership_id: 9)

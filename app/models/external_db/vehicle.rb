module ExternalDb
  class Vehicle < Record
    self.table_name = 'vehicle'
    belongs_to :source

    def sync_to_vehicle
      ::Vehicle.where(scraped_id: id).first_or_initialize.tap do |v|
        v.vehicle_make_name = make
        v.dealership = ::Dealership.where(scraped_id: source_id).first
        # v.dealership = source.sync_to_dealership
        v.vehicle_model_name = model
        %i[msrp year mileage mileage_numeric body_style engine exterior
        interior fuel_type transmission drivetrain stock_number vin trim_details
        description description_clean air_conditioning power_windows remote_keyless_entry
        speed_control am_fm_radio wireless_phone_connectivity fully_automatic_headlights
        variably_intermittent_wipers abs_brakes brake_assist dual_front_impact_airbags
        electronic_stability security_system traction_control power_steering ad_url].each do |f|
          v.send("#{f}=", send(f))
        end
        v.listing_name = "#{year} #{make} #{model}"
        v.actual_price = price
        v.created_at = created
        v.posted_at = created
        v.bumped_at = created
        v.last_found_at = last_found
        
        update_score(v)
        
        normalized_vehicle_make_name  = make.downcase.gsub(/[^0-9a-z]/, '')
        normalized_vehicle_model_name = model.downcase.gsub(/[^0-9a-z]/, '')
        
        VehicleMake.all.each do |vehicle_make|
          if vehicle_make.name.downcase.gsub(/[^0-9a-z]/, '').in?(normalized_vehicle_make_name)
            
            v.vehicle_make = vehicle_make
            
            VehicleModel.all.each do |vehicle_model|
              if vehicle_model.name.downcase.gsub(/[^0-9a-z]/, '').in?normalized_vehicle_model_name
                v.vehicle_model = vehicle_model
              end
            end
          end
        end
        
        v.save
      end
    end
    
    def update_score(v)
      
      if v.latitude.present?
        location_score = 3
      else
        location_score = 0
      end
      
      # Features are properly noted.
      if v.air_conditioning || v.power_windows || 
         v.remote_keyless_entry || v.speed_control || 
         v.am_fm_radio || v.wireless_phone_connectivity ||
         v.fully_automatic_headlights || 
         v.variably_intermittent_wipers || v.abs_brakes ||
         v.brake_assist || v.dual_front_impact_airbags ||
         v.electronic_stability || v.security_system ||
         v.traction_control || v.power_steering
        features_score = 3
        
      else
        features_score = 0
      end
      
      # Specifications are properly noted.
      spec_score = 0
      
      spec_score += 1 if v.interior.present?
      spec_score += 1 if v.exterior.present?
      spec_score += 1 if v.transmission.present?
      spec_score += 1 if v.fuel_type.present?
      spec_score += 1 if v.drivetrain.present?
      
      spec_score = (3/5)*spec_score
      
      # VIN has been properly noted.
      if v.vin.present?
        vin_score = 3
      else
        vin_score = 0
      end
      
      # Vehicle is listed by a certified dealer and dealership sends a direct
      # listing.
      if v.dealership.present? && 
         v.dealership.scraped_id.present?
        certified_dealer_score = 3
        direct_listing_score = 3
        
      elsif v.dealership.present?
        certified_dealer_score = 0
        direct_listing_score = 0
        
      else
        certified_dealer_score = 3
        direct_listing_score = 3
      end 
      
      # Seller accepts test drives, on-demand.
      test_drive_score = 3
      
      # Seller has many high-quality listings.
      if v.dealership.present?
        
        combined_score = 0

        v.dealership.vehicles.each do |vehicle|
          if vehicle.listing_score.overall_score.present?
            combined_score = vehicle.listing_score.overall_score + 
                               combined_score
          end
        end
        
        if combined_score/(v.dealership.vehicles.count + 1) <= 59
          many_listings_score = 1
        elsif combined_score/(v.dealership.vehicles.count + 1)<=79
          many_listings_score = 2
        else 
          many_listings_score = 3
        end
      
      else
        many_listings_score = 3
      end

      # Seller has several positive reviews.
      
      # Listing was recently posted or bumped.
      if v.bumped_at <= 1.day.ago
        recently_posted_score = 3
      elsif v.bumped_at <= 3.days.ago
        recently_posted_score = 2
      else
        recently_posted_score = 1
      end
      
      # Listing has many photos.
      if v.photos.count <= 3
        photos_score = 1
      elsif v.photos.count.between?(4,7)
        photos_score = 2
      else
        photos_score = 3
      end
      
      # Calculate overall score.
      overall_score = ( 100 / 30 ) * ( location_score + features_score + 
                                       spec_score + vin_score + 
                                       certified_dealer_score +
                                       direct_listing_score +
                                       test_drive_score + photos_score +
                                       # score.reviews_score + 
                                       recently_posted_score + 
                                       many_listings_score )
      
      if v.listing_score.present?
        v.listing_score.update_attributes(location_score:   
                                            location_score,
                                          features_score:   
                                            features_score,
                                          spec_score:    spec_score,
                                          vin_score:     vin_score,
                                          certified_dealer_score:
                                            certified_dealer_score,
                                          direct_listing_score:
                                            direct_listing_score,
                                          test_drive_score: 
                                            test_drive_score,
                                          photos_score:  photos_score,
                                          # reviews_score: reviews_score,
                                          recently_posted_score:
                                            recently_posted_score,
                                          many_listings_score:
                                            many_listings_score,
                                          overall_score: overall_score)
      
      else                             
        v.build_listing_score(location_score:   location_score, 
                              features_score:   features_score,
                              spec_score:       spec_score, 
                              vin_score:        vin_score, 
                              certified_dealer_score: 
                                certified_dealer_score,
                              direct_listing_score: 
                                direct_listing_score,
                              test_drive_score: test_drive_score, 
                              photos_score:     photos_score,
                              # reviews_score:    reviews_score, 
                              recently_posted_score: 
                                recently_posted_score,
                              many_listings_score: 
                                many_listings_score, 
                              overall_score:    overall_score)
      end
    end
  end
end

# Vehicle.where(dealership_id: 3).each do |vehicle|
#   vehicle.latitude  = 50.0413454
#   vehicle.longitude = -113.59097220000001
#   vehicle.save
# end

# http://www.bryceholcomb.com/2015/02/10/mapbox-and-rails/
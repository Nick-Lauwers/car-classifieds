module ExternalDb
  class Picture < Record
    
    self.table_name = 'picture'
    belongs_to :vehicle

    def sync_to_photo
      if ( vehicle.vehicle_type_id.nil? || vehicle.vehicle_type_id == 1 ) &&
         ( last_found >= 1.day.ago )
        
        if ::Photo.where(scraped_id: id).exists?
          ::Photo.where(scraped_id: id).first.tap do |p|
            p.last_found_at = last_found
            p.save or nil
          end
        
        else
          
          ::Photo.new(scraped_id: id).tap do |p|
            p.vehicle = ::Vehicle.where(scraped_id: vehicle_id).first
            p.image = open(image_url) rescue nil
            p.last_found_at = last_found
            p.save or nil
          end
          
          # Confirm that photo was saved, then update score.
          if ::Photo.where(scraped_id: id).exists?
            ::Vehicle.where(scraped_id: vehicle_id).first.tap do |v|
              
              if v.photos.count.between?(1,3)
                v.listing_score.update_attributes(photos_score: 33)
              elsif v.photos.count.between?(4,7)
                v.listing_score.update_attributes(photos_score: 67)
              elsif v.photos.count >= 8
                v.listing_score.update_attributes(photos_score: 100)
              end
                
              overall_score = ( v.listing_score.location_score + 
                                v.listing_score.features_score + 
                                v.listing_score.spec_score + 
                                v.listing_score.vin_score + 
                                v.listing_score.certified_dealer_score +
                                v.listing_score.direct_listing_score + 
                                v.listing_score.test_drive_score + 
                                ( 3 * v.listing_score.photos_score ) +
                                # v.listing_score.reviews_score + 
                                ( 2 * v.listing_score.recently_posted_score ) + 
                                v.listing_score.many_listings_score ) / 13
              
              v.listing_score.update_attributes(overall_score: overall_score)
            end
          end
        end 
      
      elsif ( vehicle.vehicle_type_id.nil? || vehicle.vehicle_type_id == 1 )
        if ::Photo.where(scraped_id: id).exists?
          ::Photo.where(scraped_id: id).first.destroy
        end
      end
    end
  end
end
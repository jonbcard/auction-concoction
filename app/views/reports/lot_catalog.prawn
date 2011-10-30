pdf.move_down 100
pdf.text "Auction Catalog", :size => 32, :style => :bold, :align => :center
pdf.text "#{@auction.description}", :size => 18, :align => :center
pdf.text "#{@auction.start.strftime("%B %d, %Y - Starting at: %I:%M %p")}", :size => 10, :align => :center
pdf.start_new_page

lots = @auction.lots.map do |lot|  
  [lot.number, lot.description]  
end  
lots.unshift(["Lot","Description"])
pdf.table lots, :header => true, :row_colors => ["FFFFFF", "DDDDDD"]


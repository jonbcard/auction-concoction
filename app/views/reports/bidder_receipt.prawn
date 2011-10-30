pdf.move_down 20
pdf.text "Receipt", :size => 20, :style => :bold
pdf.text "#{@receipt.last_name}, #{@receipt.first_name} (#{@receipt.number})"
pdf.move_down 20

purchases = @receipt.purchases.map do |p|
  [p.lot, p.description, p.price.format, p.quantity, p.item_total.format]
end
 
purchases.unshift(["Lot","Description", "Price/Unit", "Qty", "Total"])
purchases << ["","Subtotal:","","",@receipt.sub_total.format]
purchases << ["","Buyer's Fee:","",@receipt.fee_percent.to_s + "%",@receipt.fee_amount.format]
@receipt.tax_lines.each do |tax|
  purchases << ["", tax.name,"",tax.percent.to_s + "%",tax.amount.format]
end       
purchases << ["","TOTAL AMOUNT:","","",@receipt.total.format]

pdf.table purchases, :header => true
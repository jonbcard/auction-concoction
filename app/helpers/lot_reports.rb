AuctionNow.helpers do
  def generate_lot_catalog_pdf
    Prawn::Document.generate('hello.pdf') do |pdf| 
      pdf.text("Hello Prawn!") 
    end
  end
#  def generate_lot_catalog_pdf
#    table = Report.report_table(:all,
#      :only => %w[host_os rubygems_version user_key],
#      :conditions => "user_key is not null and user_key <> ’’",
#      :group=> "host_os, rubygems_version, user_key")
#    grouping = Grouping(table, :by => "host_os")
#    rubygems_versions = Table(%w[platform rubygems_version count])
#    grouping.each do |name,group|
#      Grouping(group, :by => "rubygems_version").each do |vname,group|
#        rubygems_versions << { "platform" => name,
#          "rubygems_version" => vname,
#          "count" => group.length }
#      end
#    end
#    sorted_table = rubygems_versions.sort_rows_by("count", :order => :descending)
#    g = Grouping(sorted_table, :by => "platform")
#    send_data g.to_pdf,
#      :type => "application/pdf",
#      :disposition => "inline",
#      :filename => "report.pdf"
#
#  end
end
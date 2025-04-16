ActiveAdmin.register Province do
    permit_params :name, :pst, :gst, :hst
  
    index do
      selectable_column
      id_column
      column :name
      column("PST") { |p| number_to_percentage(p.pst * 100, precision: 2) }
      column("GST") { |p| number_to_percentage(p.gst * 100, precision: 2) }
      column("HST") { |p| number_to_percentage(p.hst * 100, precision: 2) }
      column :created_at
      column :updated_at
      actions
    end
  
    filter :name
    filter :created_at
  
    form do |f|
      f.inputs do
        f.input :name
        f.input :pst, label: "PST (e.g. 0.07 for 7%)"
        f.input :gst, label: "GST (e.g. 0.05 for 5%)"
        f.input :hst, label: "HST (e.g. 0.13 for 13%)"
      end
      f.actions
    end
  
    show do
      attributes_table do
        row :name
        row("PST") { number_to_percentage(province.pst * 100, precision: 2) }
        row("GST") { number_to_percentage(province.gst * 100, precision: 2) }
        row("HST") { number_to_percentage(province.hst * 100, precision: 2) }
        row :created_at
        row :updated_at
      end
    end
  end
  
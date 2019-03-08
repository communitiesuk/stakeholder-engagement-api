class MakeOrgNameUniqueWithinRegionAndOrgType < ActiveRecord::Migration[5.2]
  def change
    add_index :organisations, [:region_id, :organisation_type_id, :name],
                              name: 'ix_orgs_region_org_type_name',
                              unique: true
  end
end

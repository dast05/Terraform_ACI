# Create TENANT
resource "aci_tenant" "Tenant_terraform-test" {
  name           = var.aci_tenant 
}

# Create VRF
resource "aci_vrf" "VRF_terraform-test" {
  tenant_dn      = aci_tenant.Tenant_terraform-test.id
  name           = var.aci_vrf
}

# Create Bridge Domains
resource "aci_bridge_domain" "BD_terraform-test" {
  for_each  = var.bridge_domains
    tenant_dn           = aci_tenant.Tenant_terraform-test.id
    relation_fv_rs_ctx  = each.value.relation_fv_rs_ctx
    name                = each.value.name
    arp_flood           = each.value.arp_flood
    ip_learning         = each.value.ip_learning
    unicast_route       = each.value.unicast_route
    depends_on = [aci_vrf.VRF_terraform-test]
}

resource "aci_subnet" "bridge_subnets" {
    for_each = var.bridge_domains
      parent_dn            = aci_bridge_domain.BD_terraform-test[each.key].id
      ip                   = each.value.subnet
      scope                = each.value.subnet_scope
}

# Create Contract Filter
resource "aci_filter" "allow_icmp" {
  tenant_dn  = aci_tenant.Tenant_terraform-test.id
   name      = "allow_icmp"
 }

resource "aci_filter_entry" "icmp" {
   name        = "icmp"
   filter_dn   = aci_filter.allow_icmp.id
   ether_t     = "ip"
   prot        = "icmp"
   stateful    = "yes"
 }

# Create Contract
resource "aci_contract" "terraform-test_con" {
  tenant_dn  = aci_tenant.Tenant_terraform-test.id
  name       = "c_ICMP_terraform-test"
 }

# Create Contract Subject
resource "aci_contract_subject" "terraform-test_sub" {
   contract_dn                  = aci_contract.terraform-test_con.id
   name                         = "cs_ICMP_terraform-test"
   relation_vz_rs_subj_filt_att = [aci_filter.allow_icmp.id]
}

# Create Application Profile(s)
resource "aci_application_profile" "AP_terraform-test" {
  tenant_dn    = aci_tenant.Tenant_terraform-test.id
  name         = var.ap_terraform-test
  depends_on = [aci_bridge_domain.BD_terraform-test]
}

# Create End Point Group(s)
resource "aci_application_epg" "EPG_terraform-test" {
  for_each  = var.aci_epgs
    name  = each.value.name
    application_profile_dn  = each.value.application_profile_dn
    relation_fv_rs_bd = each.value.relation_fv_rs_bd
    depends_on = [aci_application_profile.AP_terraform-test]
}

# Add domain to EPG
resource "aci_epg_to_domain" "epg600" {
  application_epg_dn  = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test600"
  tdn                 = "uni/phys-terraform-test_Phys" #var.phys_domain
  depends_on = [aci_application_epg.EPG_terraform-test]
}

resource "aci_epg_to_domain" "epg601" {
  application_epg_dn  = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test601"
  tdn                 = "uni/phys-terraform-test_Phys" #var.phys_domain
  depends_on = [aci_application_epg.EPG_terraform-test]
}

# Add Static Port EPG's
resource "aci_epg_to_static_path" "EPG_Static_Path1" {
  for_each  = var.aci_epg_static_path1
    application_epg_dn  = each.value.application_epg_dn
    tdn  = each.value.tdn
    encap  = each.value.encap
    mode  = each.value.mode
    instr_imedcy = each.value.instr_imedcy
    depends_on = [aci_application_epg.EPG_terraform-test]
}

resource "aci_epg_to_static_path" "EPG_Static_Path2" {
  for_each  = var.aci_epg_static_path2
    application_epg_dn  = each.value.application_epg_dn
    tdn  = each.value.tdn
    encap  = each.value.encap
    mode  = each.value.mode
    instr_imedcy = each.value.instr_imedcy
    depends_on = [aci_application_epg.EPG_terraform-test]
}

### Disse tas ut og alt over utføres. Så sjekk ping ikke går. Så legges kontrakter på EPG'ene
# Apply Consumer Contract to EPG's
resource "aci_epg_to_contract" "EPG_consumer_contract_terraform-test" {
  for_each = var.contract_consumer
    application_epg_dn = each.value.application_epg_dn
    contract_dn  = aci_contract.terraform-test_con.id
    contract_type = each.value.contract_type
    depends_on = [aci_contract.terraform-test_con]
}

# Apply Provider Contract to EPG's
resource "aci_epg_to_contract" "EPG_provider_contract_terraform-test" {
  for_each = var.contract_provider
    application_epg_dn = each.value.application_epg_dn
    contract_dn  = aci_contract.terraform-test_con.id
    contract_type = each.value.contract_type
    depends_on = [aci_contract.terraform-test_con]
}

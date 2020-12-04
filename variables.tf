#TENANT's
#-------------------------------
variable "aci_tenant" {
  default = "terraform-test"
}

variable "phys_domain" {
  default = "uni/phys-terraform-test_Phys"
}

#VRF's
#-------------------------------
variable "aci_vrf" {
  default = "vrfterraform-test"
}

#AP's
#-------------------------------
variable "ap_terraform-test" {
  default = "apterraform-test"
}

# BD's
variable "bridge_domains" {
  type = map
  default = {
    bdterraform-test600 = {
      name                = "bdterraform-test600"
      description         = "bdterraform-test600"
      relation_fv_rs_ctx  = "uni/tn-terraform-test/ctx-vrfterraform-test"
      arp_flood           = "yes"
      ip_learning         = "yes"
      unicast_route       = "yes"
      subnet              = "10.210.60.1/24"
      subnet_scope        = "private"
    },
    bdterraform-test601 = {
      name                = "bdterraform-test601"
      description         = "bdterraform-test601"
      relation_fv_rs_ctx  = "uni/tn-terraform-test/ctx-vrfterraform-test"
      arp_flood           = "yes"
      ip_learning         = "yes"
      unicast_route       = "yes"
      subnet              = "10.210.61.1/24"
      subnet_scope        = "private"
    },
  }
}

variable "aci_epgs" {
  type = map
  default = {
    epgterraform-test600 = {
      name                    = "epgterraform-test600"
      application_profile_dn  = "uni/tn-terraform-test/ap-apterraform-test"
      relation_fv_rs_bd       = "uni/tn-terraform-test/BD-bdterraform-test600"
      phys_domain             = "uni/phys-terraform-test_Phys"
    },
    epgterraform-test601 = {
      name                    = "epgterraform-test601"
      application_profile_dn  = "uni/tn-terraform-test/ap-apterraform-test"
      relation_fv_rs_bd       = "uni/tn-terraform-test/BD-bdterraform-test601"
      phys_domain             = "uni/phys-terraform-test_Phys"
    },
  }
}

variable "aci_epg_static_path1" {
  type = map
  default = {
    epgterraform-test600 = {
      application_epg_dn  = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test600"
      tdn                 = "topology/pod-1/protpaths-201-202/pathep-[L201..202:1:3:VPCIPG:WAN]"
      encap               = "vlan-600"
      mode                = "regular"
      instr_imedcy        = "immediate"
    },
    epgterraform-test601 = {
      application_epg_dn  = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test601"
      tdn                 = "topology/pod-1/protpaths-201-202/pathep-[L201..202:1:3:VPCIPG:WAN]"
      encap               = "vlan-601"
      mode                = "regular"
      instr_imedcy        = "immediate"
    },
  }
}

variable "aci_epg_static_path2" {
  type = map
  default = {
    epgterraform-test600 = {
      application_epg_dn  = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test600"
      tdn                 = "topology/pod-2/protpaths-401-402/pathep-[L401..402:1:3:VPCIPG:WAN]"
      encap               = "vlan-600"
      mode                = "regular"
      instr_imedcy        = "immediate"
    },
    epgterraform-test601 = {
      application_epg_dn  = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test601"
      tdn                 = "topology/pod-2/protpaths-401-402/pathep-[L401..402:1:3:VPCIPG:WAN]"
      encap               = "vlan-601"
      mode                = "regular"
      instr_imedcy        = "immediate"
    },
  }
}

variable "contract_consumer" {
  type = map
  default = {
    epgterraform-test600 = {
      application_epg_dn = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test600"
      contract_type = "consumer" 
    },
    epgterraform-test601 = {
      application_epg_dn = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test601"
      contract_type = "consumer"
    },
  }
}

variable "contract_provider" {
  type = map
  default = {
    epgterraform-test600 = {
      application_epg_dn = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test600"
      contract_type = "provider" 
    },
    epgterraform-test601 = {
      application_epg_dn = "uni/tn-terraform-test/ap-apterraform-test/epg-epgterraform-test601"
      contract_type = "provider"
    },
  }
}

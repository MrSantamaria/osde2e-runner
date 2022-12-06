package config

import (
	osde2e "github.com/openshift/osde2e/pkg/common/config"
)

func init() {
	// I'd have to public the init in the config file to not call this twice.
	osde2e.InitOSDe2eViper()
	osde2e.InitAWSViper()
	osde2e.LoadKubeconfig()
}

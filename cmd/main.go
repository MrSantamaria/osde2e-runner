package main

import (
	"github.com/onsi/ginkgo/v2"
	"github.com/onsi/gomega"
	_ "github.com/openshift/osde2e-runner/pkg/config"
	viper "github.com/openshift/osde2e/pkg/common/concurrentviper"
	osde2eConfig "github.com/openshift/osde2e/pkg/common/config"

	// import suites to be tested
	_ "github.com/openshift/osde2e-runner/pkg/tests/openshift"
	_ "github.com/openshift/osde2e-runner/pkg/tests/openshift/hypershift"
	_ "github.com/openshift/osde2e-runner/pkg/tests/operators"
	_ "github.com/openshift/osde2e-runner/pkg/tests/operators/cloudingress"
	_ "github.com/openshift/osde2e-runner/pkg/tests/osd"
	_ "github.com/openshift/osde2e-runner/pkg/tests/scale"
	_ "github.com/openshift/osde2e-runner/pkg/tests/state"
	_ "github.com/openshift/osde2e-runner/pkg/tests/verify"
	_ "github.com/openshift/osde2e-runner/pkg/tests/workloads/guestbook"
	_ "github.com/openshift/osde2e-runner/pkg/tests/workloads/redmine"
)

func main() {
	gomega.RegisterFailHandler(ginkgo.Fail)
	suiteConfig, reporterConfig := ginkgo.GinkgoConfiguration()

	if viper.GetString(osde2eConfig.ReportDir) == "" {
		viper.Set(osde2eConfig.ReportDir, "./out/report/")
	}

	reporterConfig.JUnitReport = "junit.xml"
	suiteConfig.FocusFiles = []string{"./pkg/tests/openshift/hypershift/verifyInstall.go"}

	//Run the tests
	ginkgo.RunSpecs(ginkgo.GinkgoT(), "hypershift", suiteConfig, reporterConfig)

}

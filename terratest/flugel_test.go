package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	// "github.com/stretchr/testify/require"
)

func TestTerraform(t *testing.T) {

	tfptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, tfptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, tfptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	output := terraform.Output(t, tfptions, "aws_ec2_tag_name")
	assert.Equal(t, "Flugel", output)
	output = terraform.Output(t, tfptions, "aws_ec2_tag_owner")
	assert.Equal(t, "InfraTeam", output)
	output = terraform.Output(t, tfptions, "aws_s3_tag_name")
	assert.Equal(t, "Flugel", output)
	output = terraform.Output(t, tfptions, "aws_s3_tag_owner")
	assert.Equal(t, "InfraTeam", output)
	//require.JSONEq(t, `{"Name":"Flugel"}`, output)
}


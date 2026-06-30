#!/bin/bash
echo "Running automated InSpec privacy compliance checks..."
inspec exec inspec-profiles/privacy-compliance --reporter=cli --no-create-profile
echo "Privacy check completed!"

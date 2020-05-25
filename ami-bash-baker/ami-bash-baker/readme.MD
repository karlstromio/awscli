**Running the script:**
Populate instance_list.txt with EC2 Instance IDs, then:
`chmod +x baker.sh`
`baker.sh`

**This will** 
 1. Fetch the name of instance(s)
 2. Create a new AMI
 3. Add datestamp to the AMI name
 4. Tag the AMI with previous version number + 1

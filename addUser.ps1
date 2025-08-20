$oauth_id = Read-Host "Enter ORCID (e.g. 0000-1111-2222-3333)"
$email = Read-Host "Enter email (must be the email used with ORCID)"

$insertUser = "INSERT INTO bi_user (orcid, name, email, created_by, updated_by, active) VALUES ('${oauth_id}', 'admin', '${email}', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', true);"
$insertRole = "INSERT INTO system_user_role (bi_user_id, system_role_id, created_by, updated_by) VALUES ((SELECT id FROM bi_user WHERE email='${email}'), (SELECT id FROM system_role WHERE domain = 'System Administrator'), '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000');"

docker exec -it bidb psql -U postgres -d bidb -c $insertUser
docker exec -it bidb psql -U postgres -d bidb -c $insertRole
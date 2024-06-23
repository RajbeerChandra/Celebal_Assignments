CREATE LOGIN new_login WITH PASSWORD = 'your_password_here';

CREATE USER new_user FOR LOGIN new_login;

ALTER ROLE db_owner ADD MEMBER new_user;
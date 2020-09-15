# GitPress CTF Challenge

This web app challenge is brought to you by braindead.

It is a multi-level challenge that requires the player to do the following:
- Perform directory enumeration to discover a Git configuration file.
- Retrieve a WordPress configuration file from a GitHub repository.
- Use compromised credentials to access a MySQL database.
- Manipulate database tables to gain administrative access to WordPress.
- Abuse the WordPress file editor to obtain shell access to the web server.
- Identify and exploit a server misconfiguration to elevate privileges to root.

### Questions

1. A wayward developer left something exposed that they shouldn't have. Can you find it? Where does it lead? Flag 1 is hidden there.
2. There's something valuable in the source code that gives you a foothold. Can you use it to break into the Knowledge Base? Flag 2 will appear when you do.
3. Great! You owned WordPress - but can you use your administrative privilege to compromise the web server? Flag 3 is waiting in the user's home directory.
4. You're almost there now. Get root and grab Flag 4!

### Flags

1. 0ee250fc09c85fec586cc1ef1fb45e7b
2. d6743b723a97c2fcb7ff821b1c1f4c4f
3. fa7d5e72ad47f497dc5a5eb8dbe62dda
4. 9e547001379783cad9e6fde3ab2eac9d

### Deploy the challenge

*Test locally:* Simply run `./start.sh` to build and run the Docker container. The website will be accessible at [http://localhost:8080](http://localhost:8080). When you're done, tear it down with `docker stop gitpress`.

*Run in AWS:* I don't know how to set this up - just make sure ports 80 and 3306 are publicly accessible. Outbound traffic should be allowed so that the player can get a reverse shell.

### Solve the challenge

1. Run `nmap` or another port scanner to discover HTTP on port 80 and MySQL on port 3306.
2. Browse to the website and observe that it is running WordPress.
3. Use any popular dirbusting tool to discover `/.git/config` publicly accessible on the website.
4. Use a tool like [gitpillage](https://github.com/koto/gitpillage) to download the site contents from GitHub, or browse to the GitHub repository using the information in the config file.
5. Browse the site contents or search for secrets and identify two files:
   - Flag 1 in `/flag1.txt`
   - MySQL credentials in `/wp-config.php`
6. Use the credentials (`dbuser:AUER2YXbiRtp4cheFGj5JH8dg`) to log in to the database on port 3306.
7. Read the contents of the `wp_users` table to identify the administrator's username (`unit_54`) and password hash.
   - Maybe try to crack the hash but fail.
8. Generate a new hash using another WordPress site or [an online generator](https://www.useotools.com/wordpress-password-hash-generator) and replace the administrator's hash with it.
9. Log in to the WordPress site as the administrator using the new password.
   - Collect Flag 2 from the admin banner.
10. Use the built-in file editor to inject PHP code in one of the theme files, then trigger it by browsing the site. Leverage this to gain shell access in one of several ways:
   - PHP web shell
   - PHP reverse shell
   - PHP file upload + binary execution
11. Perform local reconnaissance and identify that the current user is `www-data` with home directory `/var/www`.
   - Collect Flag 3 at `/var/www/flag3.txt`.
12. Check sudo privileges with `sudo -l` and find that `www-data` can execute `sudo nmap`.
   - Maybe try `sudo nmap --interactive` but the version doesn't support it.
   - Open a root shell like so:
     ```
     TF=$(mktemp)
     echo 'os.execute("/bin/sh")' > $TF
     sudo nmap --script=$TF
     ```
   - Collect Flag 4 at `/root/flag4.txt`.

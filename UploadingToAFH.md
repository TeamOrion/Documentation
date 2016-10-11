# Uploading to Orion Androidfilehost 
(Official maintainers only)

In order to get your build onto the TeamOrion AFH you need to upload it via ftp.
To do so you need to connect with sftp:

    sftp TeamOrion@uploads.androidfilehost.com

You will be promted for a password which you got from one of our team members:

    Enter password for TeamOrion
    Password:

Now upload your file:

    Connected to uploads.androidfilehost.com.
    sftp> put filename

Done!

Simpler way for lazy guys
```
curl -T ftp://USER:PASS@uploads.androidfilehost.com/ OrionOS-*.zip
```

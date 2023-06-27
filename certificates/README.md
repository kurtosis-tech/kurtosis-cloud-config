## Example of invoking the generation of certificates

```shell
sh generate_certificates.sh <hostname> <ip> <ca key password>
```

Example with password `12345678`
```shell
sh generate_certificates.sh ec2-18-205-223-95.compute-1.amazonaws.com 123.123.123.123 12345678
```

Cleaning up:
```shell
sudo rm *.pem *.srl
```

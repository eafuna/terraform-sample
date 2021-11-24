## Automation Testing

[Terratest](https://terratest.gruntwork.io) uses the Go testing framework. To use Terratest, you need to install version >= 1.13 of [Golang](https://golang.org/)

### Usage

Once Golang is installed, a test can then be performed using:

```sh
cd terratest
go test
```

The test shall conclude in less than 2 minutes, however in instances when it takes longer for some other reason you can run test setting a longer timeout period, thus:

```sh
go test -v -timeout 30m
```

Success would yeild <b>PASS</b> remark at the conclussion of the test.

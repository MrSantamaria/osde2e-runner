FROM registry.ci.openshift.org/openshift/release:golang-1.18

ENV GOFLAGS=
ENV PKG=/go/src/github.com/openshift/osde2e-test/
WORKDIR ${PKG}

COPY . .
RUN go env
RUN make check
RUN make build

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

RUN mkdir /osde2e-test
COPY --from=0 /go/src/github.com/openshift/osde2e/out/osde2e /osde2e-test

# Restore the /osde2e path for backwards compatibility
RUN ln -s /osde2e-test/test /osde2e-test
ENV PATH "/osde2e-bin:$PATH"

ENTRYPOINT [ "osde2e-test" ]

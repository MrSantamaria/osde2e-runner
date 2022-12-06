FROM registry.ci.openshift.org/openshift/release:golang-1.18

ENV GOFLAGS=""
WORKDIR github.com/MrSantamaria/osde2e-runner/

COPY . .
RUN go env
RUN make check
RUN make build

ENTRYPOINT [ "/out/osde2e-runner" ]

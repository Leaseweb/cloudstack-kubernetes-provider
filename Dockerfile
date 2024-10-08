# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM golang:1.22 as builder
COPY . /go/src/github.com/apache/cloudstack-kubernetes-provider
WORKDIR /go/src/github.com/apache/cloudstack-kubernetes-provider
RUN make clean && CGO_ENABLED=0 GOOS=linux make

FROM gcr.io/distroless/static:nonroot
COPY --from=builder /go/src/github.com/apache/cloudstack-kubernetes-provider/cloudstack-ccm /app/cloudstack-ccm
ENTRYPOINT [ "/app/cloudstack-ccm", "--cloud-provider", "cloudstack" ]

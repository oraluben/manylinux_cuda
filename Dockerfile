ARG BASE=manylinux_2_28

FROM quay.io/pypa/${BASE}_x86_64 AS base_amd64
RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo

ARG BASE
FROM quay.io/pypa/${BASE}_aarch64 AS base_arm64
RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/sbsa/cuda-rhel8.repo

FROM base_${TARGETARCH} AS base

ARG CUDA=12.9

RUN set -eux; \
    cudaver=${CUDA}; \
    v="${cudaver//./-}"; \
    yum install -y cuda-minimal-build-${v} cuda-driver-devel-${v} cuda-nvrtc-devel-${v} nvidia-driver-cuda-libs; \
    yum clean all

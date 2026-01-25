ARG BASE=manylinux_2_28

FROM quay.io/pypa/manylinux_2_28_x86_64 AS manylinux_2_28_amd64
RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo

FROM quay.io/pypa/manylinux_2_28_aarch64 AS manylinux_2_28_arm64
RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/sbsa/cuda-rhel8.repo

ARG BASE
FROM ${BASE}_${TARGETARCH} AS base

ARG CUDA=12.9

RUN set -eux; \
    cudaver=${CUDA}; \
    v="${cudaver//./-}"; \
    yum install -y cuda-minimal-build-${v} cuda-driver-devel-${v} cuda-nvrtc-devel-${v} nvidia-driver-cuda-libs; \
    yum install -y libcusparse-devel-${v} libcublas-devel-${v} libcufft-devel-${v} libcusolver-devel-${v}; \
    yum clean all

ENV PATH=/usr/local/cuda-${CUDA}/bin:$PATH

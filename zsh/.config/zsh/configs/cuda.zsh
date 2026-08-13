if [[ -d /opt/cuda/bin ]]; then
    export CUDA_HOME=/opt/cuda
    path=(/opt/cuda/bin $path)
fi

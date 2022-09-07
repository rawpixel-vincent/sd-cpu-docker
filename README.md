# Docker container with stable diffusion scripts running with the CPU only

## Build

Download the model
- `curl https://drive.yerf.org/wl/\?id\=EBfTrmcCCUAGaQBXVIj5lJmEhjoP1tgl\&mode\=grid\&download\=1 --output sd-v1-4.ckpt`

- ```docker build . -t rawpixel/sd``` (be patient)
- ```docker run -v `pwd`/data:/test-data -i -t rawpixel/sd "tail -f /dev/null"```
- In another terminal, attach a shell (`docker exec -it {container_id} sh`) and run the following command
- ```conda init zsh && source ~/.zshrc && conda activate ldm```

Scripts copied from https://github.com/CompVis/stable-diffusion and modified to run without cuda/gpu
Check the source for the possible arguments.

```bash
python custom/txt2img.py --prompt "A painting of a dragon flying over the moon" --plms --ckpt sd-v1-4.ckpt --skip_grid --n_samples 1 --ddim_steps 20 --outdir /test-data/output --seed 1111
```

```bash
python custom/img2img.py --init-img /test-data/test-sd2.jpg --prompt "Futuristic translucent basketball sneaker designed by yohji yamamoto, product photography, studio lighting" --ckpt sd-v1-4.ckpt --skip_grid --n_samples 1 --ddim_steps 100 --strength 0.25 --outdir /test-data/output --seed 1111
```

# Running with apple silicon cpu

- `git clone git@github.com:bfirsh/stable-diffusion.git stable-diffusion-apple-silicon`
- `cd stable-diffusion-apple-silicon`
- `git checkout apple-silicon-mps-support`
- `mkdir -p models/ldm/stable-diffusion-v1/`
- ```curl https://drive.yerf.org/wl/\?id\=EBfTrmcCCUAGaQBXVIj5lJmEhjoP1tgl\&mode\=grid\&download\=1 --output models/ldm/stable-diffusion-v1/model.ckpt```
- `python3 -m pip install virtualenv`
- `python3 -m virtualenv venv`
- `source venv/bin/activate`
- `brew install Cmake protobuf rust`
- `pip install -r requirements.txt`
- done

examples:

```bash
python scripts/txt2img.py --n_samples 1 --n_iter 1 --plms --ddim_steps 100 --prompt "new born baby kitten, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida" --seed 3243241
```

# Docker container to test stable diffusion scripts running with the CPU only

## Build

Clone this repository and work from the root directory

Download a model
- `curl https://drive.yerf.org/wl/\?id\=EBfTrmcCCUAGaQBXVIj5lJmEhjoP1tgl\&mode\=grid\&download\=1 --output sd.ckpt`
- `curl https://drinkordiecdn.lol/sd-v1-3-full-ema.ckpt --output sd.ckpt`

Build the container
- ```docker build . -t rawpixel/sd``` (be patient)
- ```docker run -v `pwd`/data:/test-data -v `pwd`/sd.ckpt:/sd/sd.ckpt -i -t rawpixel/sd "tail -f /dev/null"```

In another terminal, attach a shell (`docker exec -it {container_id} sh`) and run the following command
- ```conda init zsh && source ~/.zshrc && conda activate ldm```

Now you can run one of the scripts `txt2img.py` and `img2img.py`

Scripts copied from https://github.com/CompVis/stable-diffusion and modified to run without cuda/gpu
Check the source for the possible arguments.

## Examples

```bash
python custom/txt2img.py --prompt "A painting of a dragon flying over the moon" --plms --ckpt sd.ckpt --skip_grid --n_samples 1 --ddim_steps 40 --outdir /test-data/output --seed 1111
```

```bash
python custom/img2img.py --init-img /test-data/test-sd2.jpg --prompt "Futuristic translucent basketball sneaker designed by yohji yamamoto, product photography, studio lighting" --ckpt sd.ckpt --skip_grid --n_samples 1 --ddim_steps 40 --strength 0.75 --outdir /test-data/output --seed 1111
```

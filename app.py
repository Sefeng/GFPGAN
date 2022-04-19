from flask import Flask,jsonify,request
from PIL import Image

app =   Flask(__name__)


if not torch.cuda.is_available():  # CPU
    import warnings
    warnings.warn('The unoptimized RealESRGAN is slow on CPU. We do not use it. '
                    'If you really want to use it, please modify the corresponding codes.')
    bg_upsampler = None
else:
    from basicsr.archs.rrdbnet_arch import RRDBNet
    from realesrgan import RealESRGANer
    model = RRDBNet(num_in_ch=3, num_out_ch=3, num_feat=64, num_block=23, num_grow_ch=32, scale=2)
    bg_upsampler = RealESRGANer(
        scale=2,
        model_path='./tmp/RealESRGAN_x2plus.pth',
        model=model,
        tile=args.bg_tile,
        tile_pad=10,
        pre_pad=0,
        half=True)  # need to set False in CPU mode


restorer = GFPGANer(
    model_path=os.path.join('experiments/pretrained_models/GFPGANv1.3.pth'),
    upscale=2,
    arch='clean',
    channel_multiplier=2,
    bg_upsampler=bg_upsampler)

@app.route('/test', methods = ['POST'])
def ReturnJSON():
    file = request.files['image']
    # Read the image via file.stream
    # img = Image.open(file.stream)

    # img_name = os.path.basename(img_path)
    # print(f'Processing {img_name} ...')
    # basename, ext = os.path.splitext(img_name)
    input_img = cv2.imread(file.stream, cv2.IMREAD_COLOR)

    # restore faces and background if necessary
    cropped_faces, restored_faces, restored_img = restorer.enhance(
        input_img, has_aligned=args.aligned, only_center_face=args.only_center_face, paste_back=True)

    data = {
        "message" : "success",
        "image": restored_img
    }

    return jsonify(data)

if __name__=='__main__':
    app.run(debug=True)
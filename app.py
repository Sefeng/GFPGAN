from flask import Flask,jsonify,request
from PIL import Image

app =   Flask(__name__)

@app.route('/test', methods = ['POST'])
def ReturnJSON():
    file = request.files['image']
    # Read the image via file.stream
    img = Image.open(file.stream)

    data = {
        "Modules" : 15,
        "Subject" : "Data Structures and Algorithms",
        "image": [img.width, img.height]
    }

    return jsonify(data)

if __name__=='__main__':
    app.run(debug=True)
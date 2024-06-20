let capture;
let posenet;
let singlePose, skeleton;
let doublePose, skeleton2;
let actor_img;
let specs, smoke;

function setup() {
    createCanvas(800, 500);
    capture = createCapture(VIDEO);
    capture.hide();

    posenet = ml5.poseNet(capture, modelLoaded);
    posenet.on('pose', receivedPoses);

    actor_img = loadImage('images/shahrukh.png');
    specs = loadImage('images/spects.png');
    smoke = loadImage('images/cigar.png');
}

function receivedPoses(poses) {
    console.log(poses);

    if (poses.length > 0) {
        singlePose = poses[0].pose;
        skeleton = poses[0].skeleton;

        if (poses.length > 1) {
            doublePose = poses[1].pose;
            skeleton2 = poses[1].skeleton;
        } else {
            doublePose = null;
            skeleton2 = null;
        }
    }
}

function modelLoaded() {
    console.log('Model has loaded');
}

function draw() {
    image(capture, 0, 0);
    fill(255, 0, 0);

    if (singlePose) {
        for (let i = 0; i < singlePose.keypoints.length; i++) {
            ellipse(singlePose.keypoints[i].position.x, singlePose.keypoints[i].position.y, 20);
        }
        stroke(0, 0, 0);
        strokeWeight(5);
        for (let j = 0; j < skeleton.length; j++) {
            line(skeleton[j][0].position.x, skeleton[j][0].position.y, skeleton[j][1].position.x, skeleton[j][1].position.y);
        }

        // Add images to the first detected pose
        //image(specs, singlePose.nose.x - 35, singlePose.nose.y - 50, 80, 80);
        //image(smoke, singlePose.nose.x - 35, singlePose.nose.y + 10, 40, 40);
        //image(actor_img, singlePose.nose.x - 40, singlePose.nose.y - 60, 90, 90);

        if (doublePose) {
            for (let i = 0; i < doublePose.keypoints.length; i++) {
                ellipse(doublePose.keypoints[i].position.x, doublePose.keypoints[i].position.y, 20);
            }
            for (let j = 0; j < skeleton2.length; j++) {
                line(skeleton2[j][0].position.x, skeleton2[j][0].position.y, skeleton2[j][1].position.x, skeleton2[j][1].position.y);
            }
        }
    }
}

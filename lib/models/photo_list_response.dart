/*
* [
  {
    "id": "0qnRfgnZIsI",
    "width": 3110,
    "height": 4083,
    "color": "#a6a6a6",
    "blur_hash": "LFIrB7tRIVNHI.xuM{xu?w9F?as-",
    "description": null,
    "alt_description": null,
    "urls": {
      "raw": "https://images.unsplash.com/photo-1661956601030-fdfb9c7e9e2f?ixid=Mnw0MDEwOTZ8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NDQ1MTI5Nw&ixlib=rb-4.0.3",
      "full": "https://images.unsplash.com/photo-1661956601030-fdfb9c7e9e2f?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDEwOTZ8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NDQ1MTI5Nw&ixlib=rb-4.0.3&q=80",
      "regular": "https://images.unsplash.com/photo-1661956601030-fdfb9c7e9e2f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDEwOTZ8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NDQ1MTI5Nw&ixlib=rb-4.0.3&q=80&w=1080",
      "small": "https://images.unsplash.com/photo-1661956601030-fdfb9c7e9e2f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDEwOTZ8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NDQ1MTI5Nw&ixlib=rb-4.0.3&q=80&w=400",
      "thumb": "https://images.unsplash.com/photo-1661956601030-fdfb9c7e9e2f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDEwOTZ8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NDQ1MTI5Nw&ixlib=rb-4.0.3&q=80&w=200",
      "small_s3": "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1661956601030-fdfb9c7e9e2f"
    },
    "links": {
      "self": "https://api.unsplash.com/photos/0qnRfgnZIsI",
      "html": "https://unsplash.com/photos/0qnRfgnZIsI",
      "download": "https://unsplash.com/photos/0qnRfgnZIsI/download?ixid=Mnw0MDEwOTZ8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NDQ1MTI5Nw",
      "download_location": "https://api.unsplash.com/photos/0qnRfgnZIsI/download?ixid=Mnw0MDEwOTZ8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NDQ1MTI5Nw"
    },
    "likes": 391,
    "liked_by_user": false,
    "current_user_collections": [],
    "topic_submissions": {},
    "user": {
      "id": "D-bxv1Imc-o",
      "updated_at": "2023-01-22T22:31:14Z",
      "username": "mailchimp",
      "name": "Mailchimp",
      "first_name": "Mailchimp",
      "last_name": null,
      "twitter_username": "Mailchimp",
      "portfolio_url": "https://mailchimp.com/",
      "bio": "The all-in-one Marketing Platform built for growing businesses.",
      "location": null,
      "profile_image": {
        "small": "https://images.unsplash.com/profile-1609545740442-928866556c38image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32",
        "medium": "https://images.unsplash.com/profile-1609545740442-928866556c38image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64",
        "large": "https://images.unsplash.com/profile-1609545740442-928866556c38image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"
      },
      "instagram_username": "mailchimp",
      "total_collections": 0,
      "total_likes": 19,
      "total_photos": 13,
      "accepted_tos": true,
      "for_hire": false,
      "social": {
        "instagram_username": "mailchimp",
        "portfolio_url": "https://mailchimp.com/",
        "twitter_username": "Mailchimp",
        "paypal_email": null
      }
    }
  }
 ]
* */

class PhotoListItem {
  final int width;
  final int height;
  final PhotoItemUrls photoItemUrls;

  const PhotoListItem({required this.width, required this.height, required this.photoItemUrls});

  factory PhotoListItem.fromJSON(Map<String, dynamic> json) {
    final width = json['width'];
    final height = json['height'];

    final photoUrlJson = json['urls'];
    final photoUrls = PhotoItemUrls.fromJSON(photoUrlJson);

    return PhotoListItem(width: width, height: height, photoItemUrls: photoUrls);
  }
}

class PhotoItemUrls {
  final String full;
  final String thumb;

  const PhotoItemUrls({required this.full, required this.thumb});

  factory PhotoItemUrls.fromJSON(Map<String, dynamic> json) {
    final full = json['full'];
    final thumb = json['thumb'];

    return PhotoItemUrls(full: full, thumb: thumb);
  }
}
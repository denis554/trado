#Trado

[![Build Status](https://magnum.travis-ci.com/Jellyfishboy/trado.png?token=QokxWaDSkksHTjy7pT4N&branch=master)](https://magnum.travis-ci.com/Jellyfishboy/trado)

Trado is an automated enterprise e-commerce solution, built to be easy to manage and lightweight.

#Configuration

##Search

The search engine implementation within Trado is built using Elasticsearch. There are three reasons why Trado uses Elasticsearch: auto completion, conversion and personalisation. Auto completion allows search results to be suggested and returned as JSON to the user on the fly. Whereas conversion and personalisation can tailor these suggestions either by frequently visited results or a users recent purchases. This functionality allows the platform to deliver a rich user experience when navigating around the site.

You will need to ensure Elasticsearch has been successfully installed on your environment. Head over to the Elasticsearch official site for more information on installing the service on your operating system.

In order for Rails to communicate with the Elasticsearch server, a gem has been added to the application called 'searchkick'. When operating, the Elasticsearch server usually runs on port 9200, however, this can be customised along with several other settings.

If you decide to modify the setup of Elasticsearch, you will need to reindex the index database. This has already been setup in a daily cron job for the conversions, however you can trigger it with the following command:

    rake searchkick:reindex class=PRODUCT

Please note, this example is using product as the target model; be sure to replace this with your relevant model.

##Mail

Mail is an important part of an ecommerce platform, whether its an order confirmation, delivery notice or stock level warning. Therefore, to ensure reliability and scalability, Trado utilises a third party SMTP server: Mandrill.

Mandrill offers a lot of benefits including detailed delivery reporting, reliability and swift delivery times. The platform is built upon the renowned Mailchimp system; taking advantage of an extensive worldwide delivery network. All of this combined with 12,000 free emails per month collates into a formidable delivery system for your platform.

You can acquire your personal API key for Mandrill at www.mandrillapp.com, and in turn modify the global YAML setting file with your new credentials.

If you wish to use an alternative service, you can modify your development and/or production configuration to add your preferred SMTP server details.

##Payment gateway

The payment gateway within Trado utilises the very popular 'activemerchant' gem - an open source project by the Shopify team. The ideology behind the gem is to provide a solution which doesn't require setup and initialisation for each different payment method, thereby removing the requirement of managing each payment method individually.

Currently Trado only supports PayPal as a form of payment, although this will be changing in future versions to accommodate for Google checkout and credit card payments.

You will need to define two different API access credentials for development and production, as these indicate which account any successful transactions should be deposited to. You can set up a developer API credential at the PayPal sandbox - http://sandbox.paypal.com, whereas the production API credentials can be requested at the developer portal - http://developer.paypal.com. The new credentials can be added to the global YAML setting file, detailed above.

Please note, these credentials reference the desired account to receive PayPal payments, so be sure to check your credentials when deploying for production.

##Image processing

Maintaining your media library can quickly become an unnecessary hassle. Trado has been designed to provide efficient and configurable media management, with the help of several third party tools. One of these tools, Carrierwave, provides the ability to upload media to an external storage and prevent your web server from being consumed by media files. With the additional aid of ImageMagik, you can define processing dimensions and compression quality (check out the Getting Started documentation for more information on installing ImageMagik to your environment). This will result in quicker response times and allow your media to be securely managed on a separate server.

Trado has been set up to use Amazon Web Services (AWS) S3 simple storage as the external storage server. These settings can be modified in the global YAML setting file detailed above. If you would like to use a different provider, check out of the Carrierwave documentation in the Github repository wiki. 

Please note, for development purposes, the external media server configuration has only been set up for the production environment. If you would like to save media files to the local filesystem on the production environment, modify 'config/initializers/carrierwave_config.rb' to the following:

    CarrierWave.configure do |config|
    	
    	config.storage = :file
    
    end

##Asset management

The asset management within Trado is not your typical setup. When deploying the application to the production server, the application assets are configured to be uploaded to an external storage server - the storage server has been configured as the same for image uploads to ensure a clean collection of resources. There are two reasons for this architechture choice: save web server storage and increase asset response time (response times will be explained further in the Content delivery network section).

If you would like to modify the external storage server configuration to point to a different provider, consult the asset_sync gem documentation and modify the global YAML setting file retrospectively.

However, if you would like to retain your application assets on the local web server, remove the 'asset_sync' gem amd the asset_sync.rb initializer file.


##Content devlivery network


Ensuring swift response times in your application is an important attribute for your end user experience. In order to improve the speed of Trado, a content delivery network configuration has been introduced. To ensure consistency AWS (Amazon web services) Cloudfront has been utilised.

##Sitemap generator

Gaining a prominent web presence is an important part to running a successful website. Listing rich content from your site on popular search engines is a sure fire way of increasing presence, however updating a sitemap after every update can be a tedious approach. Trado has been set up to automatically create a new sitemap every day, utilising data from category, product, about and contact pages. In turn Google and Bing are pinged to indicate a new sitemap is ready for retrieval and processing.

You will need to modify the sitemap.host value in the global YAML setting file detailed above, with your preferred domain name. If you would like more information on configuring this functionality, check out the sitemap_generator gem.


##How to contribute

* Fork the project
* Create your feature or bug fix
* Add the requried tests for it.
* Commit (do not change version or history)
* Send a pull request against the *development* branch

##Copyright

Copyright (c) 2014 Tom Dallimore. See LICENSE for details.

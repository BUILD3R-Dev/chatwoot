# Rebranding Chatwoot to MyHelpChat: A Detailed Plan

This document outlines the steps to rebrand a self-hosted Chatwoot installation to "MyHelpChat", including replacing the logo and removing "Powered By" messages. The approach uses a Rails Engine to ensure maintainability and avoid conflicts with future Chatwoot updates.

## 1. Create a Rails Engine

A Rails Engine will encapsulate our changes, making them modular and less likely to be overwritten by updates.

*   **Generate the Engine:**
    *   Run the following command in the Chatwoot root directory (`/Users/dustin/GitHub/chatwoot`):

        ```bash
        bundle exec rails plugin new myhelpchat_branding --mountable --full
        ```

        This will create a new directory `myhelpchat_branding` containing the engine's code. The `--mountable` option makes it an isolated engine, and `--full` includes necessary files.

*   **Configure the Engine:**
    *   Edit `myhelpchat_branding/lib/myhelpchat_branding/engine.rb`:

        ```ruby
        module MyhelpchatBranding
          class Engine < ::Rails::Engine
            isolate_namespace MyhelpchatBranding

            initializer 'myhelpchat_branding.override' do |app|
              # Add overrides here
              # Example for overriding views:
              app.paths['app/views'] << "#{config.root}/app/views"
            end
          end
        end
        ```

*   **Mount the Engine:**
    *   Edit Chatwoot's main `config/routes.rb` file and add the following line *within* the `Rails.application.routes.draw do` block:

        ```ruby
        mount MyhelpchatBranding::Engine, at: '/'
        ```
        This mounts the engine at the root path, allowing it to override routes.

* **Add Engine to Gemfile:**
    * Edit Chatwoot's main `Gemfile` and add the following line to the end of the file:
    ```ruby
    gem 'myhelpchat_branding', path: 'myhelpchat_branding'
    ```
* **Run bundle install:**
    * Run `bundle install` in the Chatwoot root directory to install the new engine.

## 2. Override Files

---
### **Progress Update (as of 2025-04-22)**

#### ✅ Rails Engine Setup
- Engine `myhelpchat_branding` created, configured, and mounted.
- Engine added to Gemfile and installed.

#### ✅ Branding Asset Checklist
- Created `myhelpchat_branding/BRANDING_ASSETS_CHECKLIST.md` with required logo filenames, paths, and dimensions.

#### ✅ View and Config Overrides (completed):
- `app/views/super_admin/application/_navigation.html.erb` — Updated to use MyHelpChat logo and name.
- `app/views/super_admin/devise/sessions/new.html.erb` — Updated to use MyHelpChat branding and logo.
- `app/views/installation/onboarding/index.html.erb` — Updated to use MyHelpChat branding and logo.
- `app/views/layouts/vueapp.html.erb` — Meta description rebranded to MyHelpChat.
- `app/views/layouts/mailer/base.liquid` — "Powered by" branding/link removed.
- `config/installation_config.yml` — All branding-related values overridden for MyHelpChat.
- `config/locales/en.yml` — All visible references to Chatwoot in integration descriptions overridden to MyHelpChat.

#### ⏳ Next Steps
- Add new logo SVGs to `myhelpchat_branding/app/assets/images/` as listed in the checklist.
- Test overrides in development environment.
- Continue with any additional view or locale overrides as needed.

---

The core of the rebranding involves overriding specific Chatwoot files with our customized versions. We'll place these overridden files within the `myhelpchat_branding` engine, mirroring the directory structure of the original files.

*   **Logo:**
    *   Place the new logo files (e.g., `myhelpchat-logo.svg`, `myhelpchat-logo.png`, `myhelpchat-logo-dark.png`) in `myhelpchat_branding/app/assets/images/`.  The exact filenames and formats needed will be determined by examining where the original logos are used.
    *   Update references to the old logo in overridden view files (see below) to point to the new logo files.  You will need to examine the files listed below to find the exact references.

*   **Brand Name:**
    *   **Views:** Override views that contain the "Chatwoot" name.  Based on previous searches, likely candidates include (but may not be limited to):
        *   `app/views/layouts/vue.html.erb`
        *   `app/views/layouts/devise.html.erb`
        *   `app/views/layouts/dashboard.html.erb`
        *   `app/views/layouts/sdk.html.erb`
        *   `app/views/layouts/public.html.erb`
        *   `app/views/admin/accounts/_form.html.haml`
        *   `app/views/admin/accounts/new.html.haml`
        *   `app/views/admin/accounts/edit.html.haml`
        *   `app/views/admin/labels/edit.html.haml`
        *   `app/views/admin/labels/new.html.haml`
        *   `app/views/admin/labels/form.html.haml`
        *   `README.md`
        *   `public/404.html`
        *   `public/422.html`
        *   `public/500.html`
        *   `public/manifest.json`

        To override a view, create a file with the *same path* within the engine. For example, to override `app/views/layouts/vue.html.erb`, create `myhelpchat_branding/app/views/layouts/vue.html.erb`. Copy the original content and replace "Chatwoot" with "MyHelpChat".

    *   **Locales:** Override locale files (e.g., `config/locales/en.yml`, and other language files in that directory) that contain the "Chatwoot" name or "Powered by" messages. Create corresponding files in the engine (e.g., `myhelpchat_branding/config/locales/en.yml`) and modify the relevant strings.  You will need to examine each locale file to find all instances.
    * **Configuration:** Update `config/installation_config.yml` by overriding it in the engine. Change `INSTALLATION_NAME` and `BRAND_NAME` to "MyHelpChat". Also update `WIDGET_BRAND_URL`. Create `myhelpchat_branding/config/installation_config.yml` and copy the contents, making the necessary changes.
    * **Database:** You may need to update any database records that contain the brand name. This might include the `widget_color` in the `accounts` table (from `db/schema.rb`) and label `color` values in `lib/seeders/seed_data.yml`. This can be done via a Rails migration within the engine, or by directly updating the database after the engine is set up.  A migration is recommended.
    * **Javascript:** Update `histoire.config.ts` by overriding it in the engine. Change the `title` to '@myhelpchat/design' and update the `logo` paths. Create `myhelpchat_branding/histoire.config.ts` and copy the contents, making the necessary changes.

*   **"Powered By" Messages:**
    *   Locate and override the views or locale files containing the "Powered By" messages.  The previous search did not find an exact match for "Powered By", so you will need to examine the views related to the chat widget and emails.  Look in `app/views` and `config/locales`.  Also, check `app/views/layouts/sdk.html.erb` and `config/installation_config.yml` (WIDGET_BRAND_URL).
    *   Remove or modify the "Powered By" text in the overridden files.

## 3. Overriding Methods (Optional)

If you need to modify the behavior of Chatwoot (e.g., change how the logo URL is generated), you can override methods in controllers or helpers.

*   **Example (Overriding a Helper):**
    *   If you need to change the `logo_url` helper method (hypothetical example), you would:
        1.  Find the original helper (e.g., in `app/helpers/application_helper.rb`).
        2.  Create a file in the engine with the same path: `myhelpchat_branding/app/helpers/application_helper.rb`.
        3.  Define the `logo_url` method within that file, effectively overriding the original.

        ```ruby
        # myhelpchat_branding/app/helpers/application_helper.rb
        module ApplicationHelper
          def logo_url
            # Your custom logic to return the new logo URL
            '/myhelpchat_branding/myhelpchat-logo.svg' # Example - adjust path as needed
          end
        end
        ```

## 4. Testing

After making changes, thoroughly test the rebranded application:

*   Start the Rails server (`rails s`).
*   Visit different pages, including the dashboard, widget, and public-facing pages.
*   Ensure the new brand name and logo are displayed correctly.
*   Verify that "Powered By" messages are removed or customized.
*   Test email notifications to ensure they reflect the rebranding.

## 5. Deployment

Deploy the changes to your self-hosted Chatwoot instance. The exact steps will depend on your deployment setup (Docker, manual, etc.). Since this is a Rails Engine, you will need to ensure the engine is included in your deployment.  You will likely need to rebuild your Docker image if you are using Docker.

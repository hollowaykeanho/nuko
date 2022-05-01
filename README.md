[![language](https://img.shields.io/badge/core%20language-Bash-1313c3.svg?style=for-the-badge)]()
[![license](https://img.shields.io/badge/License-MIT-orange.svg?style=for-the-badge)]()
[![release](https://img.shields.io/badge/release%20quality-alpha-red.svg?style=for-the-badge)]()
[![Supported Platform](https://img.shields.io/badge/supported%20platform-linux-1313c3.svg?style=for-the-badge)]()

[![banner](https://lh3.googleusercontent.com/ZJzNajgm_pkYVxKEkMuVLit_eMi-8mXjFT6M1EnkdOv37yBolv0NMvgpPHHJ05tdTKU2zU65nBInQquG9h-ckUkK4jqfDwKgvB_tGkXLpHnxPalzgeepn4NCqInpo1vVnKBjJ10SkuchuyT-NLPtr3JBFKEnRXSqPBwMangdOUYCG5JF5GF7pe5KlADEhUkXxUGA87JyKFRb6vbuU7eed3L77u33N1yAps6Buhh-WWGVBDtYzC6Sdtns_DymbGp8PLCrqmjRu3A3wAn1njVigtqWUs_UGTy8VPTcpdSfTsg3dN-1W7w5hGnuApoKN4XnDg16Pyv1HG0NxeM6N0-8CJ3vVwtH-wwB3Xm_PSxSvT1caPflcBGPP1Z8JIbZaiyGMpFF-dO1AWKyPE3s0iyUAvZ79GZlRSmjn5lYkxLYmOEinRauuQnT6Q46aoshdOFBpJ4xxZg6MmgNxZ0a9u5CNsm1SDepFJzp2iO32_ImaMte_0Ecb9OVflnXjRgQfRGxi3zMXH6QKyzANkuYW1ia8EifYHcEgA8QT1O9JUL8WnymC9uahMEynaGci3c0Ep4bCV2aT_2Yn1uvZTUCrtzt_R4KAw4QGfss0X39_UELF0K-wBag-x2mnc5weNd8_v7hyhZkD_HcAX0Sc6GAExAJBWkchWtEKaOG=w1920-h960-no)]()
# Nuko
A program for removing Android bloatwares from the phone using the ADB, without
rooting or breaking the manufacturer's updates. This is for the developer who
had enough with bloatwares packed by the manufacturers and clotted the phone
system with no way of uninstalling. Use cautiously.

> **CAUTION**
>
> This application is currently in Alpha release and it meant for phone
> developer who knows how ADB works. **Please BE CAREFUL. It's not an ordinary
> tool.**
>

## Announcement
1.  I'm currently pausing the development due to underwhelming response. Please
    raise an issue and let me know should I continue to proceed with the
    project.
2.  I'm looking for any open-source contributors wanted to develop nuko. Let me
    know so that I can add you in! Cheers.




### Tested Devices
1. Huawei Mate 10




## Installing
### Snap (Preferred)
```
$ sudo snap install nuko
```

### Ubuntu
```
$ sudo add-apt-repository ppa:zoralab/nuko
$ sudo apt-get update -y
$ sudo apt install nuko
```




## Usage
1. Setup ADB in your Linux computer system (https://www.xda-developers.com/install-adb-windows-macos-linux/).
1. **Backup ALL data**. The phone should be in 'factory reset' condition.
2. Connect your phone to the PC and ensure you enabled 'USB Debugging' properly.
3. Start ADB by `$ adb start-server`.
4. Test ADB connection using `$ adb shell getprop ro.product.name`. If you
don't get anything, you'll need to restart your adb.
5. Once ADB is established, run `$ nuko -r -adb path/to/your/adb`. Follow
the instruction inside **especially the warnings** and wish you fair wind!

> NOTE:
>
> 1) No screenshot available yet. If you don't understand any instruction above,
>    you should start learning Android and `adb` fundamentals.
>
> 2) In any cases, a factory reset should restore the phone back to normal.
>
> 3) Nuko is meant to remove quite a lot of bloatwares not limited to keyboard
>    and some google apps as well. Be sure to install a keyboard like `gboard`
>    or `Hacker's Keyboard` before nuking your phone.




## License
This repository is licensed under [MIT License](https://gitlab.com/ZORALab/nuko/blob/master/LICENSE).




## Contribute
Before reading the guide, ensure you're fully abide to the following guidelines:
1. [BASH/Shell Script](https://gitlab.com/ZORALab/Resources/blob/master/coding_guidelines/shell_bash.md)




This [guide](https://gitlab.com/ZORALab/nuko/blob/master/CONTRIBUTING.md)
should brings you up to speed for contributing back to this repository.




## Story behind the project
### Backstory
As Android is taking over the world, many manufacturers failed to understand
that packing a *non-removable* software into the phone. These software can take
quite a punch over the device battery, performance, and recently, screen spaces.

![original_phone_screen](https://lh3.googleusercontent.com/Lyhxal-Bc9WqJkFg4yugox2wCIkzeWsiyjz3epMWbH8TzfhJnqhZ24SuXEAVJU4Zv1AjMIUMn3efB2yKLrxVgVVFz81tKVamTVaEd3qCA8aWDnt2zZ78V7LqPiibILxaR7PIsJmONaMx1yw68yN3ivJLkFirRReFawNRqWKBVXADZN_OjMiNrZ436Pf9bC68Msa4JYVTyLKy-vddX0Aq__n9gexOANQQA6UfjboBVheud3u1ntlWeadXFkwldGBRZnqmRUJ48VaBnvVBBFcl05FLdmMEWBWIUlHMLKXBFB8JGWgpn1HzfhTy_-pXvt8DrjrnRshBYk6sBcOeEbmWeYSMHRhW_P1vjnfB9gEeGU-tsOYoersShMhzBUtIP0vWxXoZVdwiRIyCAD41pek7jbi561yiPofyQEqe6fCd22c935ZFhJu8JhRnkCJw7SQ4W3e8Rn6VfMCncmEwI8MHkUw2fzHPNSufOYvxhquOUerkQGSkL3PN5XW9RYjCAYdus-15fe53-O5D149xfKzPlqpCpYhQTPqcnhnSnTV2Bm993bFdXgjJrQ5U5irp73J7dRRDzHQjXDgtpf0lZR2s43y3M8Lbf1TNRWvsSq5UGvWt_29WD7YJ6-wpWcG4_Ykc8A3VEA2CcMcY02FuQnwJ14UiIjqbkH7b=w542-h963-no)

The problem though, is you can't remove them from your phone. If you do, by the
means of rooting, you'll void the warranty. Hence, as a customer from the
devices, you're stuck in a chicken-and-egg situation.

One way not to void the warranty, is by carefully remove them from your current
running Android session using `adb`. Although it doesn't totally uninstall the
bloatwares, It provides a workaround for conserving the screen spaces and RAM,
therefore, battery power.

![nuked_phone_screen](https://lh3.googleusercontent.com/hFDhYQNNVkPMhV0rVbNiBbqtxdCxMoha0UdugvOkZuATDOxZUOvuM3KuYpZSI7kWE7T_0vs-O6tK7A-_InbewkHPvO-9k02Yb3qt69v3DLhu7A9xW6mFY2LD2tRhoQfoB83s-61APDYEvKC85EA7hytfdrVWxDegKDZECm8yJ9y4CZBRPQ0GvmKJ_GB4QB1m4FoNPgzClwvzAzp-hWF9u_J0mYfjWNxYRhomeg4xtxEeEpBcTEKGaLh6VWzUgBDiB-K5MSDjSwMbFWYkxWpIuaQ7bXQjOF0HGELdIXrMCZ_MRh_-bkju_-2m6ri3GK0NUeLRIPJdnvQCPKXkkB90Ot8ZNuXgugrkKXGTwazKD7wYCWAOO1SESIzgMiOnsBHmo1WIm4InafMEObqwr95H9Dabbm3amxtr15Z0B3rV5zAtcq_JOu3q_hDXWhH88cEtpFS13MzZxWSECrZG8DpML1JQdLmB4_6uO2VK43mEDmSdyoeRaBdzbUMpXK3v_y4lyY6c4tbIflWi3pWERB0oGjtpOCzjOzbQbBreWNHgGVw-qChjtzDkBdJeDxZyVrnHtZAZFTJ4s07epLgDLpx3fpvXR8luOnc5i8E_09n4c5pqiHM2UQY-p97W_cFAEOdtNjcUsNvYOGQS9V7ZUVDnQfZBr7Pc721b=w542-h963-no)

The list of removable bloatwares are identified via a *long* hours of try and
errors. Hence, the project nuko is created. This project records the list so
that users can repeatedly `nuke` the bloatwares off the current session when
a manufacturer update or factory reset happens.

### Breaks Warranty?
As far as the implementation means, it shouldn't break the warranty since we
aren't rooting and modifying the ROM.

### Master Reset
In fact, if you don't like nuko, a simple factory reset restores everything
back to normal.

### Why Not Root?
3 reasons.

***Expensive Device*** - Let's just say, I paid the money to get the device.
I don't expect to break my own device just because I want it to be clean
dashboard and only allow services I really use to run.

<br/>

***Complications Black Hole*** - Besides, rooting leads to various complication.
I don't enjoy policing every single app before installing: One wrong move can
sometimes bricks your device.

<br/>

***Keeping Things Simple*** - Keep things simple: don't get into the
manufacturers' way to serve you better with their updates; while achieving a
cleaner device.

### Source of motivation?
We don't think having 3 pre-installed SMTP mailbox apps into a device is making
any sense since user only use 1 email account and 1 app per device, at a time,
not all 3 of them. **That's just a starter**.

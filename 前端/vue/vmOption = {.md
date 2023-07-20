vmOption = {\
el: \"#mainvue\",\
data: {\
entity: {\
ContainerTaskEntity: {\
F_ContainerNo:\"\",\
},\
},\
replyData: {\
F_Content:\"\"\
}\
},\
methods: {\
send: function () {\
if (!\$(\'#sendData\').lrValidform()) {\
return false;\
}\
var postData = {\
strEntity: JSON.stringify(\$(\'#sendData\').lrGetFormData())\
};\
\$.lrSaveForm(top.\$.rootUrl +
\'/SR_Transfer/ContainerManager/DraftSend?keyValue=\' +\
keyValue, postData, function (res) {\
vm.reLoad();\
}, true);\
},\
reply: function (keyValue) {\
if (!\$(\'#replyData\').lrValidform()) {\
return false;\
}\
var postData = {\
strEntity: JSON.stringify(vm.replyData)\
};\
\$.lrSaveForm(top.\$.rootUrl +
\'/SR_Transfer/ContainerManager/DraftReply?keyValue=\' +\
keyValue, postData, function (res) {\
vm.reLoad();\
vm.replyData.F_Content = \"\";\
},true);

},\
reLoad: function () {\
if (!!keyValue) {\
\$.lrSetForm(top.\$.rootUrl +
\'/SR_Transfer/ContainerManager/GetDraftData?keyValue=\' +\
keyValue, function (data) {\
vm.entity = data;\
for (var id in data) {\
\$(\'\[data-table=\"\' + id + \'\"\]\').lrSetFormData(data\[id\]);\
}\
});\
}\
}\
},\
beforeCreate: function () {\
},\
created: function () {\
},\
beforeMount: function () {\
},\
mounted: function () {\
\$(\'.lr-form-wrap\').lrscroll();\
\$(\'#F_Data\').lrDataSourceSelect({ code: \'Supplier\', value:
\'f_supplierid\', text: \'f_suppliername\'\
\$(\'#F_File\').lrUploader({ multiple: false });\
\$(\'#F_Data\').on(\'change\', function () {\
var value = \$(this).lrselectGet();\
var supplierId = value;\
learun.httpAsyncGet(top.\$.rootUrl +
\'/BaseModule/Bas_Supplier/GetEntity?keyValue=\' + s\
if (res.code == learun.httpCode.success) {\
if (!res.data.F_ContactEMail) {\
learun.alert.error(\"报关行没有设置接收邮箱，请进行设置！\");\
}\
else {\
\$(\'#F_EMail\').val(res.data.F_ContactEMail);\
}

}\
}\
else {\
learun.alert.error(res.info);\
}\
});\
});\
this.reLoad();\
},\
beforeUpdate: function () {\
},\
updated: function () {\
},\
beforeDestroy: function () {\
},\
destroyed: function () {\
}\
};

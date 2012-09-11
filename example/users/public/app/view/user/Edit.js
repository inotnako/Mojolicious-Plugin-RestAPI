Ext.define('H.view.user.Edit', {
    extend: 'Ext.window.Window',
    alias : 'widget.useredit',

    requires: ['Ext.form.Panel'],

    title : 'Edit User',
    layout: 'fit',
    autoShow: true,
    height: 120,
    width: 280,
    butAction: 'save',

    initComponent: function() {
        this.items = [
            {
                xtype: 'form',
                padding: '5 5 0 5',
                border: false,
                style: 'background-color: #fff;',

                items: [
                    {
                        xtype: 'textfield',
                        name : 'full_name',
                        fieldLabel: 'Name'
                    },
                    {
                        xtype: 'textfield',
                        name : 'email',
                        fieldLabel: 'Email'
                    }
                ]
            }
        ];

        this.buttons = [
            {
                text: 'Save',
                action: this.butAction
            },
            {
                text: 'Cancel',
                scope: this,
                handler: this.close
            }
        ];

        this.callParent(arguments);
    }
});

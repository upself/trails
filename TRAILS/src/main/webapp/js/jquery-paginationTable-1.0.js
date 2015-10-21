/**
 * JQuery pagination table plugin Author: Jackie King vndwbwan@cn.ibm.com
 * 
 */
!function($) {
	"use strict";

	var pageEvent = {
		pageClicked : 'pageClicked'
	}

	//object
	var Page = function(element, options) {
		var defaultOption = {
			pageSize : 100,
			pageBtnCount : 8,
			showFirstLastBtn : true,
			firstBtnText : 'First',
			lastBtnText : 'Last',
			prevBtnText : "Pre",
			nextBtnText : "Next",
			remote : {
				url : null,
				type : 'GET',
				params : null,
				success : null,
				beforeSend : null,
				complete : null,
				pageIndexName : 'currentPage',
				pageSizeName : 'pageSize',
				totalName : 'data.total',
				pageOrderName : 'sort',
				pageOrderTypeName : 'dir'
			},
			orderColumns : null,
			showInfo : true,
			infoFormat : '<strong>{start} ~ {end}</strong> of <strong>{total}</strong> results',
			showPageSizes : true,
			pageSizeItems : null,
			debug : false
		}

		this.$element = $(element);
		/*<p class="ibm-table-navigation">
			<span class="ibm-primary-navigation">
				<span><strong>1-20</strong> of <strong>50</strong> results</span>
				<span class="ibm-table-navigation-links">
					<a class="ibm-forward-em-link" href="#">First</a>
					<a class="ibm-forward-em-link" href="#">Pre</a>
					<a class="ibm-forward-em-link" href="#">1</a>
					<a class="ibm-forward-em-link" href="#">2</a>
					<a class="ibm-forward-em-link" href="#">3</a>
					<a class="ibm-forward-em-link" href="#">4</a>
					<a class="ibm-forward-em-link" href="#">Next</a>
					<a class="ibm-forward-em-link" href="#">Last</a>
				</span>
			</span>
			<span class="ibm-secondary-navigation">
				<span>Results per page: <strong>20</strong> </span>
				<span class="ibm-table-navigation-links">
					<a href="__REPLACE__">50</a>
					<a href="__REPLACE__">100</a>
					<a href="__REPLACE__">All</a>
				</span>
			</span>
		</p>*/
		this.$pageBar = $('<p class="ibm-table-navigation"></p>');
		this.$pageBarPri = $('<span class="ibm-primary-navigation">');
		this.$pageBarPri_info = $('<span></span>');
		this.$pageBarPri_pages = $('<span class="ibm-table-navigation-links"></span>');
		this.$pageBarSec = $('<span class="ibm-secondary-navigation"></span>');
		this.$pageBarSec_pageSizeInfo = $('<span style="margin-left: 3px;"></span>');
		this.$pageBarSec_pageSizeItems = $('<span class="ibm-table-navigation-links"></span>');
		this.$pageLoading = $('<span class="ibm-spinner-large"></span>');

		this.options = $.extend(true, {}, defaultOption,$.fn.paginationTable.defaults, options);
		this.total = this.options.total || 0;
		this.pageSizeItems = this.options.pageSizeItems || [ 20, 50, 100, 200 ];
		this.currentPageIndex = 1;
		this.currentPageSize = this.options.pageSize;
		this.pageCount = getPageCount(this.total, this.currentPageSize);
		this.orderColumns = this.options.orderColumns || [];
		this.currentPageOrder = '';
		this.currentPageOrderType = '';
		
		//init method
		var init = function(obj) {
			var that = obj;
			
			//init page bar structure
			that.$pageBarPri.append(that.$pageBarPri_info);
			that.$pageBarPri.append(that.$pageBarPri_pages);
			that.$pageBar.append(that.$pageBarPri);
			
			that.$pageBarSec.append(that.$pageBarSec_pageSizeInfo);
			that.$pageBarSec.append(that.$pageBarSec_pageSizeItems);
			that.$pageBar.append(that.$pageBarSec);
			
			//init loading effect
			that._resizeLoading();
			
			//init pagination table with a page bar and a loading image
			that.$element.after(that.$pageLoading);
			that.$element.after(that.$pageBar);
			
			//bind sort columns
			if(that._isEnableOrder()){
				var thList = that.$element.children('thead').children('tr').children('th');
				for(var i = 0; i < that.orderColumns.length; i++){
					if(that.orderColumns[i] !== null && that.orderColumns[i] !=='' && typeof thList[i] !== 'undefined'){
						$(thList[i]).children('a').children('span').data('pageOrder', that.orderColumns[i]);
					}	
				}
			}
			
			//Render pagination table by directly or by remote
			that._remoteOrRender(1);
			
			//License user's operations
			that.$element.on('click', {
				page : that
			}, function(event) {
				eventHandler(event);
			});
			
			that.$pageBar.on('click', {
				page : that
			}, function(event) {
				eventHandler(event);
			});
		}

		//handler user's operations
		var eventHandler = function(event) {
			var that = event.data.page;
			var $target = $(event.target);
			//page click
			if (event.type === 'click' && $target.data('pageIndex') !== undefined && !$target.hasClass('active')) {
				var pageIndex = $(event.target).data("pageIndex");
				that.debug('event[ pageClicked ] : pageIndex = ' + (pageIndex));
				that._remoteOrRender(pageIndex);
			} else if (event.type === 'click' && $target.data('pageSize') !== undefined) {
				var pageSize = $(event.target).data("pageSize");
				that.currentPageSize = pageSize;
				that.debug('event[ pageSizeClicked ] : pageSize = ' + pageSize);
				that._remoteOrRender(1);
			} else if(event.type === 'click' && $target.data('pageOrder') !== undefined) {
				var pageOrder = $(event.target).data("pageOrder");
				var pageIndex = that.currentPageIndex;
				
				//reset order type and css
				if(that.currentPageOrder == pageOrder){
					if(that.currentPageOrderType == 'Asc'){
						that.currentPageOrderType = 'Desc';
						$target.parent().parent().removeClass("tablesorter-headerAsc");
						$target.parent().parent().removeClass("ibm-sort-up");
						$target.parent().parent().addClass("tablesorter-headerDesc");
						$target.parent().parent().addClass("ibm-sort-down");
					}else{
						that.currentPageOrderType = 'Asc';
						$target.parent().parent().removeClass("tablesorter-headerDesc");
						$target.parent().parent().removeClass("ibm-sort-down");
						$target.parent().parent().addClass("tablesorter-headerAsc");
						$target.parent().parent().addClass("ibm-sort-up");
					}
				}else{
					that.currentPageOrderType = 'Asc';
					$target.parent().parent().removeClass("tablesorter-headerDesc");
					$target.parent().parent().removeClass("ibm-sort-down");
					$target.parent().parent().addClass("tablesorter-headerAsc");
					$target.parent().parent().addClass("ibm-sort-up");
				}
				that.currentPageOrder = pageOrder;
				
				that.debug('event[ pageOrderClicked ] : pageOrder = ' + pageOrder + ', orderType = ' + that.currentPageOrderType + ', pageIndex = ' + pageIndex);
				that._remoteOrRender(pageIndex);
			}
		}

		//init on load
		if (typeof this.options.total === 'undefined' && this.options.remote.url === null) {
			console && console.error("[init error] : the options must have the parameter of 'remote.url' or 'total'.");
		} else {
			init(this);
		}
	}

	//method
	Page.prototype = {
		_remoteOrRender : function(pageIndex) {
			if (this.options.remote.url != null) {
				this._remote(pageIndex);
			} else {
				this._renderPagination(pageIndex);
			}
		},
		_remote : function(pageIndex, params) {
			var that = this;
			if (isNaN(parseInt(pageIndex)) || typeof pageIndex === "object") {
				params = pageIndex;
				pageIndex = null;
			}
			if (isNaN(parseInt(pageIndex))) {
				pageIndex = this.currentPageIndex;
			}
			var pageParams = {};
			pageParams[this.options.remote.pageIndexName] = pageIndex;
			pageParams[this.options.remote.pageSizeName] = this.currentPageSize;
			if(this._isEnableOrder() && this.currentPageOrder != null && this.currentPageOrder.trim() != ''
						&& this.currentPageOrderType != null && this.currentPageOrderType.trim() != ''){
				pageParams[this.options.remote.pageOrderName] = this.currentPageOrder;
				pageParams[this.options.remote.pageOrderTypeName] = this.currentPageOrderType;
			}
			
			this.options.remote.params = deserializeParams(this.options.remote.params);
			if (params) {
				params = deserializeParams(params);
				this.options.remote.params = $.extend({},this.options.remote.params, params);
			}
			var requestParams = $.extend({}, this.options.remote.params,pageParams);
			$
					.ajax({
						url : this.options.remote.url,
						type : this.options.remote.type,
						dataType : 'json',
						data : requestParams,
						async : false,
						beforeSend : function(XMLHttpRequest) {
							that._resizeLoading();
							that.$pageLoading.show();
							if (typeof that.options.remote.beforeSend === 'function'){
								that.options.remote.beforeSend(XMLHttpRequest);
							}
						},
						complete : function(XMLHttpRequest, textStatu) {
							that.$pageLoading.hide();
							if (typeof that.options.remote.complete === 'function'){
								that.options.remote.complete(XMLHttpRequest,textStatu);
							}
								
						},
						success : function(result) {
							var total = GetCustomTotalName(result,that.options.remote.totalName);
							if (total == null || total == undefined) {
								console && console.error("the response of totalName :  '" + that.options.remote.totalName+ "'  not found");
							} else {
								that._updateTotal(total);
								if (typeof that.options.remote.success === 'function'){
									that.options.remote.success(result,pageIndex);
								}
								that._renderPagination(pageIndex);
							}
						}
					})
		
		},
		_renderPagination : function (pageIndex) {
            this.currentPageIndex = pageIndex;
            
            var info = renderInfo(this.currentPageIndex, this.currentPageSize, this.total, this.options.infoFormat);
            var pages = renderPages(this.currentPageIndex, this.currentPageSize, this.total, this.options.pageBtnCount, this.options.firstBtnText, this.options.lastBtnText, this.options.prevBtnText, this.options.nextBtnText, this.options.showFirstLastBtn);
            var pageSizeInfo = renderPageSizeInfo(this.currentPageSize);
            var pageSizeItems = renderPageSizeItems(this.currentPageSize, this.pageSizeItems, this.total);
            
           
            
            this.$pageBarPri_info.empty().append(info);
            this.$pageBarPri_pages.empty().append(pages);
            this.$pageBarSec_pageSizeInfo.empty().append(pageSizeInfo);
            this.$pageBarSec_pageSizeItems.empty().append(pageSizeItems);
            
            if (this.pageCount > 0) {
                this.$pageBarPri_pages.show();
                if (this.options.showInfo){
                	this.$pageBarPri_info.show();
                } 
                if (this.options.showPageSizes) {
                	this.$pageBarSec_pageSizeInfo.show();
                	this.$pageBarSec_pageSizeItems.show();
                }
            }
            else {
            	this.$pageBarPri_info.hide();
            	this.$pageBarPri_pages.hide();
            	this.$pageBarSec_pageSizeInfo.hide();
                this.$pageBarSec_pageSizeItems.hide();
            }
            
		},
		_updateTotal : function(total) {
			this.total = total;
			this.pageCount = getPageCount(total, this.currentPageSize);
		},
		_resizeLoading : function(){
			this.$pageLoading.css("cssText", "height: "+ (this.$element.children('tbody').height() || 50) + "px !important");
			this.$pageLoading.css({
				"position" : "absolute",
				"top" : "" + this.$element.children('tbody').position().top + "px",
				"left" : "" + this.$element.children('tbody').position().left + "px",
				"width" : "" + this.$element.children('tbody').width() + "px",
				"padding" : "0px",
				"background-color" : "#EEE",
				"opacity" : "0.7"
			});
		},
		_isEnableOrder : function(){
			if(this.options.remote.url === null){
				console && console.error("[enable sortable error] : the options must have the parameter of 'remote.url' when you want to use sortable feature.");
				return false;
			} else if (this.orderColumns === null || typeof this.orderColumns === 'undefined' || this.orderColumns.length <=0) {
				return false;
			} else{
				return true;
			}
		},
		
		destroy: function () {
            this.$element.unbind().data("page", null).empty();
        },
		debug : function(message, data) {
			if (this.options.debug && console) {
				message && console.info(message);
				data && console.info(data);
			}
		}
	}
	
	//Global method
	var renderInfo = function(currentPageIndex, currentPageSize, total, infoFormat) {
		var startNum = (currentPageIndex - 1) * currentPageSize + 1;
		var endNum = (currentPageIndex) * currentPageSize;
		endNum = endNum >= total ? total : endNum;
		return infoFormat.replace('{start}', startNum).replace('{end}', endNum).replace('{total}', total);
	}
	
	var renderPages = function(pageIndex, pageSize, total, pageBtnCount, firstBtnText, lastBtnText, prevBtnText, nextBtnText, showFirstLastBtn) {
		pageIndex = pageIndex == undefined ? 1 : parseInt(pageIndex); 
		var pageCount = getPageCount(total, pageSize);
		var html = [];

		if (pageCount <= pageBtnCount) {
			//Numeric buttons
			html = renderPage(1, pageCount, pageIndex);
		} else {
			//First Last Prev Next buttons
			var firstPage = renderPerPage(firstBtnText || 1, 1);
			var lastPage = renderPerPage(lastBtnText || pageCount, pageCount);
			var prevPage = renderPerPage(prevBtnText, pageIndex - 1);
			var nextPage = renderPerPage(nextBtnText, pageIndex + 1);
			
			// Numeric buttons with or without First Last Prev Next buttons 
			var symmetryBtnCount = (pageBtnCount - 1 - 4) / 2;
			if (!showFirstLastBtn) symmetryBtnCount = symmetryBtnCount + 1;
			var frontBtnNum = (pageBtnCount + 1) / 2;
			var behindBtnNum = pageCount - ((pageBtnCount + 1) / 2);

			symmetryBtnCount = symmetryBtnCount.toString().indexOf('.') == -1 ? symmetryBtnCount : symmetryBtnCount + 0.5;
			frontBtnNum = frontBtnNum.toString().indexOf('.') == -1 ? frontBtnNum : frontBtnNum + 0.5;
			behindBtnNum = behindBtnNum.toString().indexOf('.') == -1 ? behindBtnNum : behindBtnNum + 0.5;
			if (pageIndex <= frontBtnNum) {
				if (showFirstLastBtn) {
					html = renderPage(1, pageBtnCount - 2, pageIndex);
					html.push(nextPage);
					html.push(lastPage);
				} else {
					html = renderPage(1, pageBtnCount - 1, pageIndex);
					html.push(nextPage);
				}
			} else if (pageIndex > behindBtnNum) {
				if (showFirstLastBtn) {
					html = renderPage(pageCount - pageBtnCount + 3, pageBtnCount - 2, pageIndex);
					html.unshift(prevPage);
					html.unshift(firstPage);
				} else {
					html = renderPage(pageCount - pageBtnCount + 2, pageBtnCount - 1, pageIndex);
					html.unshift(prevPage);
				}
			} else {
				if (showFirstLastBtn) {
					html = renderPage(pageIndex - symmetryBtnCount, pageBtnCount - 4, pageIndex);
					html.unshift(prevPage);
					html.push(nextPage);
					html.unshift(firstPage);
					html.push(lastPage);
				} else {
					html = renderPage(pageIndex - symmetryBtnCount, pageBtnCount - 2, pageIndex);
					html.unshift(prevPage);
					html.push(nextPage);
				}
			}
		}
		return html;
	}
	
	var renderPage = function(beginPageNum, count, currentPage) {
		var html = [];
		for (var i = 0; i < count; i++) {
			var page = renderPerPage(beginPageNum, beginPageNum);
			if (beginPageNum == currentPage) {
				page.css("color", "red");
				page.addClass("active");
			}

			html.push(page);
			beginPageNum++;
		}
		return html;
	}
	
	var renderPerPage = function(text, value) {
		return $('<a class="ibm-forward-em-link" href="javascript:void(0)" style="margin-left:3px;" data-page-index="'+ value + '">' + text + '</a>');
	}
	
	var renderPageSizeInfo = function(currentPageSize){
		return $('<strong>Results per page: '+currentPageSize+'</strong> ');
	}
	
	var renderPageSizeItems = function(currentPageSize, pageSizeItems, total){
		var html = [];
		for (var i = 0; i < pageSizeItems.length; i++) {
			if (pageSizeItems[i] != currentPageSize) {
				html.push($('<a href="javascript:void(0)" style="margin-left:3px;" data-page-size="'+ pageSizeItems[i]+ '">'+ pageSizeItems[i] + '</a>'));
			}
		}
		html.push($('<a href="javascript:void(0)" style="margin-left:3px;" data-page-size="'+ total+ '">All</a>'));
		return html;
	}
	
	var getPageCount = function(total, pageSize) {
		var pageCount = 0;
		var total = parseInt(total);
		var i = total / pageSize;
		pageCount = i.toString().indexOf('.') != -1 ? parseInt(i.toString().split('.')[0]) + 1 : i;
		return pageCount;
	}
	
	var deserializeParams = function(params) {
		var newParams = {};
		if (typeof params === 'string') {
			var arr = params.split('&');
			for (var i = 0; i < arr.length; i++) {
				var a = arr[i].split('=');
				newParams[a[0]] = decodeURIComponent(a[1]);
			}
		} else if (params instanceof Array) {
			for (var i = 0; i < params.length; i++) {
				newParams[params[i].name] = decodeURIComponent(params[i].value);
			}
		} else if (typeof params === 'object') {
			newParams = params;
		}
		return newParams;
	}
	var checkIsPageNumber = function(pageIndex, maxPage) {
		var reg = /^\+?[1-9][0-9]*$/;
		return reg.test(pageIndex) && parseInt(pageIndex) <= parseInt(maxPage);
	}
	var GetCustomTotalName = function(object, totalName) {
		var arr = totalName.split('.');
		var temp = object;
		var total = null;
		for (var i = 0; i < arr.length; i++) {
			temp = mapObjectName(temp, arr[i]);
			if (!isNaN(parseInt(temp))) {
				total = temp;
				break;
			}
			if (temp == null) {
				break;
			}
		}
		return total;
	}
	var mapObjectName = function(data, mapName) {
		for ( var i in data) {
			if (i == mapName) {
				return data[i];
			}
		}
		return null;
	}

	//plugin
	$.fn.paginationTable = function(option) {
		var args = arguments;
		return this
				.each(function() {
					var $this = $(this);
					var data = $this.data('page');
					if (!data
							&& (typeof option === 'object' || typeof option === 'undefined')) {
						var options = typeof option == 'object' && option;
						var data_api_options = $this.data();
						options = $.extend(options, data_api_options);
						$this.data('page', (data = new Page(this, options)));
					} else if (data && typeof option === 'string') {
						data[option].apply(data, Array.prototype.slice.call(
								args, 1));
					} else if (!data) {
						console
								&& console
										.error("jQuery Pagination Plugin is uninitialized.");
					}
				});
	}
}(window.jQuery)
var _createClass = function () {
    function defineProperties(target, props) {
        for (var i = 0; i < props.length; i++) {
            var descriptor = props[i];
            descriptor.enumerable = descriptor.enumerable || false;
            descriptor.configurable = true;
            if ("value" in descriptor) descriptor.writable = true;
            Object.defineProperty(target, descriptor.key, descriptor);
        }
    }

    return function (Constructor, protoProps, staticProps) {
        if (protoProps) defineProperties(Constructor.prototype, protoProps);
        if (staticProps) defineProperties(Constructor, staticProps);
        return Constructor;
    };
}();

function _classCallCheck(instance, Constructor) {
    if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
    }
}

function _possibleConstructorReturn(self, call) {
    if (!self) {
        throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
    }
    return call && (typeof call === "object" || typeof call === "function") ? call : self;
}

function _inherits(subClass, superClass) {
    if (typeof superClass !== "function" && superClass !== null) {
        throw new TypeError("Super expression must either be null or a function, not " + typeof superClass);
    }
    subClass.prototype = Object.create(superClass && superClass.prototype, {
        constructor: {
            value: subClass,
            enumerable: false,
            writable: true,
            configurable: true
        }
    });
    if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass;
}

var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

var Carousel = function (_React$Component) {
    _inherits(Carousel, _React$Component);

    function Carousel(props) {
        _classCallCheck(this, Carousel);

        var _this = _possibleConstructorReturn(this, (Carousel.__proto__ || Object.getPrototypeOf(Carousel)).call(this, props));

        _this.state = {
            items: _this.props.items,
            active: _this.props.active,
            direction: ""
        };
        _this.rightClick = _this.moveRight.bind(_this);
        _this.rightClick5 = _this.moveRight5.bind(_this);
        _this.leftClick = _this.moveLeft.bind(_this);
        _this.leftClick5 = _this.moveLeft5.bind(_this);
        return _this;
    }

    _createClass(Carousel, [{
        key: "generateItems",
        value: function generateItems() {
            var items = [];
            var level;
            console.log(this.state.active);
            for (var i = this.state.active - 2; i < this.state.active + 3; i++) {
                var index = i;
                if (i < 0) {
                    index = this.state.items.length + i;
                } else if (i >= this.state.items.length) {
                    index = i % this.state.items.length;
                }
                level = this.state.active - i;
                items.push(React.createElement(Item, {key: index, id: this.state.items[index], level: level}));
            }
            return items;
        }
    }, {
        key: "moveLeft",
        value: function moveLeft() {
            var newActive = this.state.active;
            newActive--;
            this.setState({
                active: newActive < 0 ? this.state.items.length - 1 : newActive,
                direction: "left"
            });
        }
    }, {
        key: "moveLeft5",
        value: function moveLeft5() {
            var newActive = this.state.active;
            newActive= newActive-5;
            this.setState({
                active: newActive < 0 ? this.state.items.length - 1 : newActive,
                direction: "left"
            });
        }
    }, {
        key: "moveRight",
        value: function moveRight() {
            var newActive = this.state.active;
            this.setState({
                active: (newActive + 1) % this.state.items.length,
                direction: "right"
            });
        }
    }, {
        key: "moveRight5",
        value: function moveRight5() {
            var newActive = this.state.active;
            this.setState({
                active: (newActive + 5) % this.state.items.length,
                direction: "right"
            });
        }
    }, {
        key: "render",
        value: function render() {
            return React.createElement(
                "div",
                {id: "carousel", className: "noselect"},
                React.createElement(
                    "div",
                    {className: "arrow-left", onClick: this.leftClick},
                    React.createElement("i", {className: "fi-arrow-left"})
                ),
                React.createElement(
                    "div",
                    {className: "arrow-left5", onClick: this.leftClick5},
                    React.createElement("i", {className: "fi-arrow-left5"})
                ),
                React.createElement(
                    ReactCSSTransitionGroup,
                    {transitionName: this.state.direction},
                    this.generateItems()
                ),
                React.createElement(
                    "div",
                    {className: "arrow-right5", onClick: this.rightClick5},
                    React.createElement("i", {className: "fi-arrow-right5"})
                ),
                React.createElement(
                    "div",
                    {className: "arrow-right", onClick: this.rightClick},
                    React.createElement("i", {className: "fi-arrow-right"})
                )
            );
        }
    }]);

    return Carousel;
}(React.Component);

var Item = function (_React$Component2) {
    _inherits(Item, _React$Component2);

    function Item(props) {
        _classCallCheck(this, Item);

        var _this2 = _possibleConstructorReturn(this, (Item.__proto__ || Object.getPrototypeOf(Item)).call(this, props));

        _this2.state = {
            level: _this2.props.level
        };
        return _this2;
    }

    _createClass(Item, [{
        key: "render",
        value: function render() {
            var className = "item level" + this.props.level;
            return React.createElement(
                "div",
                {className: className},
                this.props.id
            );
        }
    }]);

    return Item;
}(React.Component);

var items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
ReactDOM.render(React.createElement(Carousel, {items: items, active: 0}), document.getElementById("app"));